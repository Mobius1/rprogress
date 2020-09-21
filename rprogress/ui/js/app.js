const ui = document.getElementById('radial_progress');
let running = false;
let customDial = false

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

    if (data.stop && customDial) {
        running = false;
        customDial.stop();

        PostData("progress_stop");
    }
};

window.onload = function (e) {
    window.addEventListener('message', function (event) {
        onData(event.data);
    });
};

function PostData(type) {
    fetch(`https://${GetParentResourceName()}/${type}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        }
    });
}