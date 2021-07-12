const ui = document.getElementById('radial_progress');
let running = false;
let customDial = []
let staticDial = false
let miniGame = false
let Runner = [];

window.onData = function (data) {
    if ( data.MiniGame ) {
        if ( !miniGame && !running ) {
            miniGame = new RadialProgress({
                r: data.Radius,
                s: data.Stroke,
                x: data.x,
                y: data.y,
                color: data.Color,
                bgColor: data.BGColor,
                rotation: data.Rotation,
                maxAngle: data.MaxAngle,
                progress: data.From,
                zone: data.Zone,
                onStart: function() {
                    running = true;
                },                
                onComplete: function(progress) {
                    if ( progress >= 100 ) {
                        this.start(0, 100, data.Duration);
                    } else {
                        this.start(100, 0, data.Duration);
                    }               
                },                 
            });         

            miniGame.render(ui);

            miniGame.start(data.To, data.From, data.Duration);
        }
    } else {
        if (data.display && !running) {
            customDial[data.customId] = new RadialProgress({
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
                    Runner[data.customId] = true;

                    this.container.classList.add(`label-${data.LabelPosition}`);
                    this.label.textContent = data.Label;

                    PostData("progress_start", data)
                },
                onChange: function(progress, t, duration) {
                    if ( data.ShowTimer ) {
                        this.indicator.textContent = `${((duration - t) / 1000).toFixed(2)}s`;
                    }

                    if ( data.ShowProgress ) {
                        this.indicator.textContent = `${Math.ceil(progress)}%`;
                    }

                    if ( data.ShowIncrementer ) {
                        this.indicator.textContent = `${Math.ceil(progress)} ${data.LabelIncrement}`;
                    }
                },     
                onComplete: function () {
                    this.indicator.textContent = "";
                    this.label.textContent = "";
                    this.hide();

                    setTimeout(() => {
                        this.remove();
                    }, 1000)
  
                    PostData("progress_complete", data);
                    Runner[data.customId] = false;
                }
            });

            customDial[data.customId].render(ui);

            customDial[data.customId].start(data.To, data.From, data.Duration);
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
    }

    if (data.stop && customDial) {
        running = false;
        if (data.customId != null)
        {
            Runner[data.customId] = false
            customDial[data.customId].stop();
            customDial[data.customId] = null
        }
        else
        {
            customDial.forEach(element => {
                element.stop();
            });
            customDial = [];
        }
        PostData("progress_stop");
    }
};

window.onload = function (e) {
    window.addEventListener('message', function (event) {
        onData(event.data);
    });

    window.addEventListener("keydown", e => {
        if ( e.key == " " ) {
            if ( miniGame && running ) {
                miniGame.pause();
                
                PostData("progress_minigame_input", {
                    success: miniGame.progress > miniGame.zoneMin && miniGame.progress < miniGame.zoneMax
                })

                setTimeout(() => {
                    miniGame.hide();
                    setTimeout(() => {
                        running = false;
                        miniGame.stop();
                        miniGame = false;

                        PostData("progress_minigame_complete");
                    }, 1000)
                }, 2000)
            }                 
        } 
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