function WebSocketImpresion() {
    var textoImpresion = '';
    var ws = null;
    var URL = 'ws://localhost:8887';
    var impSAFI = this;

    this.conectar = function(){

        if ('WebSocket' in window) {
            ws = new WebSocket(URL);
        } else if ('MozWebSocket' in window) {
            ws = new MozWebSocket(URL);
        } else {

            mensajeSisRetro({
                mensajeAlert : 'Su navegador no soporta WebSockets',
                muestraBtnAceptar: true,
                txtAceptar : 'Aceptar',
                txtCabecera:  'Servidor de Impresión',
                funcionAceptar : function(){                    
                },
                funcionCerrar   : function(){}  
            });
        }


        ws.onopen = function() {
            // pintamos mensaje
            $('#spanPrinter').show();
  			    if($('#lookAndFeel').asNumber()>0){
      				$('#imgPrinterSAFI').attr('src','images/impresora/01/conectado_2.png');
      			} else {	
                  	$('#imgPrinterSAFI').attr('src','images/impresora/conectado_2.png');
      			}
            $('#imgPrinterSAFI').attr('title','Conectado');
        };
    
        ws.onmessage = function(event) {
            var message = event.data;
            /*
             * Pintamos el Mensaje que el servidor de impresion halla retornado
             * puede ser un mensaje de error o validaciones del mismo
             */
            if(message != ''){
                mensajeSisRetro({
                    mensajeAlert : message,
                    muestraBtnAceptar: true,
                    txtAceptar : 'Aceptar',
                    txtCabecera:  'Servidor de Impresión',
                    funcionAceptar : function(){                    
                    },
                    funcionCerrar   : function(){}  
                });
            }
            
        };
    
        ws.onclose = function() {
            // Mostramos el mensaje cuando se desconecte del servidor de impresion
      			if($('#lookAndFeel').asNumber()>0){
      				$('#imgPrinterSAFI').attr('src','images/impresora/01/desconectado_2.png');
      			} else {	
                  	$('#imgPrinterSAFI').attr('src','images/impresora/desconectado_2.png');
      			}
            $('#imgPrinterSAFI').attr('title','Desconectado');
            impSAFI.mensajeSinConexion();
  
        };
    
        ws.onerror = function(event) {
            /*
             * Se muestra cada ves que sea un error no controlado
             */
      			if($('#lookAndFeel').asNumber()>0){
      				$('#imgPrinterSAFI').attr('src','images/impresora/01/desconectado_2.png');
      			} else {	
                  	$('#imgPrinterSAFI').attr('src','images/impresora/desconectado_2.png');
      			}
            $('#imgPrinterSAFI').attr('title','Desconectado');
            impSAFI.mensajeSinConexion();
        };

    }
  

    this.findPrinter = function(nombreImpresora) {
        if (ws != null) {
            if(ws.readyState == 1){
                var impresoraTicket = "1&" + nombreImpresora;
                ws.send(impresoraTicket); // Se establece la impresora
            }else{
                impSAFI.conectar();
            }

            
        }else{
            impSAFI.mensajeSinConexion();
        }
    };

    this.append = function(lineaTicket) {
        textoImpresion = textoImpresion + lineaTicket;
    };

    this.print = function() {
        if (ws != null) {
            if(ws.readyState == 1){
                var infoTicket = "2&" + textoImpresion;
                ws.send(infoTicket); // Se envia el Texto a imprimir
                textoImpresion ="";     
            }else{
                impSAFI.mensajeSinConexion();
            }       
        }else{
            impSAFI.mensajeSinConexion();
        }
    };


    this.getEstatus = function(){
        estatus = 'D';
        if (ws != null) {
            if(ws.readyState == 1){
                estatus = 'C';
            }else{
                estatus = 'D';
            }
        }else{
            estatus = 'D';
        }

        return estatus;
    }


    this.mensajeSinConexion = function(){
	  	$('#spanPrinter').show();
        mensajeSisRetro({
            mensajeAlert : '<img src="images/impresora/desconectado_2.png" width="50px"><br>Impresora sin Conexión',
            muestraBtnAceptar: true,
            muestraBtnCancela: false,
            txtAceptar : 'Aceptar',
            txtCabecera:  '¡Atención!',
            funcionAceptar : function(){                    
            },
            funcionCerrar   : function(){}  
        });
    }

}