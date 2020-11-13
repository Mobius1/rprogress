const ui = document.getElementById('radial_progress');
let running = false;
let customDial = false
let staticDial = false

window.onData = function (data) {
    if (data.display && !running) {
        customDial = new RadialProgress({
            r: data.Radius,
            s: data.Stroke,
            x: data.x,
            y: data.y,
            color: data.Color,
            bgColor: data.BGColor,
            rotation: data.Rotation,
            maxAngle: data.MaxAngle,
            progress: data.From,
            easing: data.Easing,
            onStart: function() {
                running = true;

                this.container.classList.add(`label-${data.LabelPosition}`);
                this.label.textContent = data.Label;

                PostData("progress_start")
            },
            onChange: function(progress, t, duration) {
                if ( data.ShowTimer ) {
                    this.indicator.textContent = `${((duration - t) / 1000).toFixed(2)}s`;
                }

                if ( data.ShowProgress ) {
                    this.indicator.textContent = `${Math.ceil(progress)}%`;
                }                
            },     
            onComplete: function () {
                this.indicator.textContent = "";
                this.label.textContent = "";
                this.container.classList.add("done");

                setTimeout(() => {
                    this.remove();
                }, 1000)
  
                PostData("progress_complete");
                
                running = false;
            }
        });

        customDial.render(ui);

        customDial.start(data.To, data.From, data.Duration);
    }

    if ( data.static ) {
        if ( !staticDial ) {
            staticDial = new RadialProgress({
                r: data.Radius,
                s: data.Stroke,
                x: data.x,
                y: data.y,
                color: data.Color,
                bgColor: data.BGColor,
                rotation: data.Rotation,
                maxAngle: data.MaxAngle,
                progress: data.From,
                onChange: function(progress) {
                    if ( data.ShowProgress ) {
                        this.indicator.textContent = `${Math.ceil(progress)}%`;
                    }                
                },                 
            });

            staticDial.container.classList.add(`label-${data.LabelPosition}`);
            staticDial.label.textContent = data.Label;            
        } else {
            if (data.show) {
                staticDial.render(ui);
            }
            
            if (data.hide) {
                staticDial.remove();
            }               

            if ( data.progress !== false ) {
                staticDial.setProgress(data.progress)
            }

            if (data.destroy) {
                staticDial.remove();
                staticDial = false;
            }             
        }              
    }

    if (data.stop && customDial) {
        running = false;
        customDial.stop();
        customDial = false;

        PostData("progress_stop");
    }
};

window.onload = function (e) {
    window.addEventListener('message', function (event) {
        onData(event.data);
    });
};

function PostData(type, obj) {
    if ( obj === undefined ) {
        obj = {}
    }
    fetch(`https://${GetParentResourceName()}/${type}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(obj)
    }).then(resp => resp.json()).then(resp => resp).catch(error => console.log('RPROGRESS FETCH ERROR! ' + error.message));  
}