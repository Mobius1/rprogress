const ui = document.getElementById('rprogress');
let running = false;
let customDial = false
let staticDial = false
let miniGame = false

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
                zoneColor: data.ZoneColor,
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
                }          
            });         

            miniGame.render(ui);

            miniGame.start(data.To, data.From, data.Duration);
        }
    } else {
        if (data.display && !running) {
            if ( data.Type == 'linear' ) {
                customDial = new LinearProgress({
                    w: data.Width,
                    h: data.Height,
                    x: data.x,
                    y: data.y,
                    padding: data.Padding,
                    cap: data.Cap,                
                    color: data.Color,
                    bgColor: data.BGColor,
                    progress: data.From,
                    easing: data.Easing,
                    onStart: function() {
                        running = true;

                        this.label.textContent = data.Label;

                        PostData("progress_start")
                    },    
                    onComplete: function () {
                        this.label.textContent = "";

                        PostData("progress_complete");

                        this.hide();

                        setTimeout(() => {
                            this.remove();
                        }, 1000)
                    
                        running = false;
                    }                    
                });
            } else if ( data.Type == 'radial' || !data.Type ) {
                customDial = new RadialProgress({
                    r: data.Radius,
                    s: data.Stroke,
                    x: data.x,
                    y: data.y,
                    padding: data.Padding,
                    cap: data.Cap,                
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
                        PostData("progress_complete");

                        this.indicator.textContent = "";
                        this.label.textContent = "";
                        this.hide();

                        setTimeout(() => {
                            this.remove();
                        }, 1000)
                    
                        running = false;
                    }
                });
            }

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
                    padding: data.Padding,
                    cap: data.Cap,
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

    if (data.stop) {
        running = false;

        if ( miniGame ) {
            miniGame.stop();
            miniGame = false
        } else if ( customDial ) {
            customDial.stop();
            customDial = false
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
                }, 1000)
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