var timeOutServerHuella = 0;
var checkTimeServerHuella ;
var timeDateServerHuella = new Date();
var objServerHuella = {};
var mensajeResp;
var NumeroCta = "";
function HuellaServer(parametrosHuella){

    this.IP_SERVER_HUELLA = '127.0.0.1';
    this.PUERTO_SERVER_HUELLA = '4444';
    this.GRABAR_HUELLA = 1;
    this.numeroHuellasRegistradas = 0;
    this.webSocket = null; // objeto Principal
    this.iniciarConexion();
    this.Mano = {
        'I' : 'Izquierda',
        'D' : 'Derecha'
    }

    this.estatus_huella_digital = {
        '': { html: '<div class="estatus_huella no_registrada">NO REGISTRADAS<div>', descripcion: "NO REGISTRADAS" },
        'I': { html: '<div class="estatus_huella registrada">REGISTRANDO<div>', descripcion: "REGISTRANDO" },
        'V': { html: '<div class="estatus_huella pendiente">VALIDACI&Oacute;N PENDIENTE<div>', descripcion: "VALIDACION PENDIENTE" },
        'P': { html: '<div class="estatus_huella validando">PROCESO DE VALIDACI&Oacute;N<div>', descripcion: "PROCESO DE VALIDACIÓN" },
        'A': { html: '<div class="estatus_huella autorizada">AUTORIZADAS<div>', descripcion: "AUTORIZADAS" },
        'R': { html: '<div class="estatus_huella repetida">DUPLICIDAD DETECTADA<div>', descripcion: "DUPLICIDAD DETECTADA" },
    }

    this.catInstrumento = {
        CLIENTE : 'CLI',
        CUENTA  : 'AHO',
        USUARIO  : 'USU',
    }

    this.instance;
    this.estaConectado = false;
    this.operacionEnProceso = false;
    this.tipoInstrumento = '';
    this.tipoRegistroHuella = '';

    this.mensajeHuella = '<div class="alertInfo"><div class="cabecera"><img src="images/huella.png" class="" style="margin: 0 auto; width: 34px; padding: 5px">'
                    + '  <div class="clearfix"></div></div>'
                    + '  <div class="contenido"><div  id="mensajeContenido"></div><div id="timerSrvHuella"  class="timerSrvHuella"></div></div>'
                    + '  <div class="footer" id="footerSrvHuella"></div>'
                    + '</div> ';
    this.btnAceptar = '<button class="submit" id="btnHuellaAceptar">Aceptar</button>';
    this.btnCancelar = '<button class="submit" id="btnHuellaCancelar">Cancelar Transacción</button>';
    this.txtReloj   = '<span id="timerSrvHuella" class="timerSrvHuella">00:00</span>';

    this.bitacoraBean = {
        tipoOperacion   :  0,
        tipoTransaccion :  1,
        descriOperacion: '',
        clienteUsuario  : '',
        numeroTransaccion: 0,
        fecha           : '1900-01-01 00:00:00',
        tipo            : 'C',
        caja            : parametroBean.cajaID,
        sucursalCteUsr  : parametroBean.sucursal

    }

    this.catListaCombo={
            'combo':3
        };

    this.metodo = {

        enrolamientoCliente : 1,
        validaHuellaVentanilla: 2,
        cargaFirmante: 3,
        enrolamientoCuenta: 4,
        enrolamientoUsuario: 5,
        cancelarOperacionActual: 6,
        validaHuellaUsuario: 7,
        enrolamientoUsuarioServicios: 9
    }

    /*Lista de operaciones que no requieren huella digital */
    this.noRequiereHuella = [
        11, // cambiar efectivo
        16, // pago de remesas
        17, // pago de oportunidades
        27, // ajuste por sobrante
        28, // ajuste por faltante
        38, // gastos y anticipos
        39, // devolución de gastos y anticipo
        18, // recepcion de cheques SBC
        19  // Aplicacion de cheques SBC
        ];

    this.operacionesVentanilla = {
        /* Operaciones que afectan el saldo de la cuenta */
        retiroEfectivo      :  1,
        devolucionGarLiq    :  5,
        desemboCred         :  7,
        aplicaPolizaRiesgo  :  9,
        tranferenciaCuenta  : 10,
        devAportacionSocial : 13,
        aplicaSegVidaAyuda  : 15,
        pagoServifun        : 25,
        cobroApoyoEscolar   : 26,
        haberesExmenor      : 40,

    /* Operaciones que no requieren huella */
    abonoCuenta     :  2,
    pagoCredito         :  3,
    depGarantiLiquida   :  4,
    comAperturaCred     :  6,
    cobroPolizaCobRiesgo : 8,
    cambiarEfectivo     : 11,
    cobSeguroVidaAyuda  : 14,
    pagoRemesas         : 16,
    pagoOportunidades   : 17,
    recepcionDocSBC     : 18,
    aplicacionDocSBC    : 19,
    prepagoCredito      : 20,
    pagoServicios       : 21,
    recCarteraCastigada : 22,
    ajustePorSobrante   : 27,
    ajustePorFaltante   : 28,
    gastosAnticipos     : 38,
    devGastosAnticipos  : 39,
    transferenciaInterna : 41,


    }

    this.autorizacionPantalla = {
        autorizacionInversion   : 1,
        cancelacionInversion    : 2,
        reinversionInversion    : 3,
        vencimientoInversion    : 4,
        desembolsoCredito       : 5,
        envioSpei               : 6
    }

    // Operaciones con usuario de servicios que SI requieren huella digital.
    this.requiereHuellaUsuarioServ = {
        16: 'pago de remesas'
    };

    this.parametros = {
        fnHuellaValida : function(){},
        fnHuellaInvalida : function(){},
        fnGrabarHuella: function(){}
    }

    $.extend(this.parametros,parametrosHuella);

    this.respuesta = {
        huellaValida : '200',
        grabarHuella : '500',
        enrolamientoTerminado: '300',
        modoOperacionExitoso: '100',
    }

    this.tipoMetodo = {
      enrolamientoCliente: 1,
      cargaFirmantes: 2,
      seleccionaFirmante: 3,
    }

    clearInterval(checkTimeServerHuella);
    timeOutServerHuella = 0;

    objServerHuella = this;

    setTimeout(function(){
        objServerHuella.reConectarSocket();
    },100);
}


HuellaServer.prototype.iniciarConexion = function(paramConexion){

        this.webSocket = new WebSocket("ws://"+this.IP_SERVER_HUELLA+":"+this.PUERTO_SERVER_HUELLA+"/");

        this.buttonStatusID  = 'statusSrvHuella_'+Math.round(Math.random() * 100);
        this.buttonStatusDiv = '<div id="'+this.buttonStatusID+'" class="huella huella-on"><img src="images/huella.png" class="huella-img"></div>';

        $('#statusSrvHuella').html(this.buttonStatusDiv);

        $('#'+this.buttonStatusID).click(function(event) {
            objServerHuella.reConectarSocket();
        });

        this.webSocket.onopen = function() {

            objServerHuella.estaConectado = true;
            objServerHuella.inicializarInterfazHuella();

            $('#'+objServerHuella.buttonStatusID).removeClass("huella-off");
            $('#'+objServerHuella.buttonStatusID).addClass("huella-on");
            $('#'+objServerHuella.buttonStatusID).attr('title','Lector de Huella Conectado');

        };

        this.webSocket.onclose = function() {

            objServerHuella.estaConectado = false;

            $('#'+objServerHuella.buttonStatusID).removeClass("huella-on");
            $('#'+objServerHuella.buttonStatusID).addClass("huella-off");
            $('#'+objServerHuella.buttonStatusID).attr('title','Lector de Huella Desconectado');

        };

        this.webSocket.onerror = function(err) {

            objServerHuella.estaConectado = false;

            $('#'+objServerHuella.buttonStatusID).removeClass("huella-on");
            $('#'+objServerHuella.buttonStatusID).addClass("huella-off");
            $('#'+objServerHuella.buttonStatusID).attr('title','Lector de Huella Desconectado');

        };


        this.webSocket.onmessage = function (evt) {
            mensajeResp = JSON.parse(evt.data);
            /* -- -------------------------- --
            *  Respuesta de métodos disponibles
            *  -- -------------------------- --
             */

             if (mensajeResp.codigoRespuesta == objServerHuella.respuesta.huellaValida) {
                if( $('#'+objServerHuella.buttonStatusID).is(':visible')) {
                    desbloquearPantalla();
                    objServerHuella.parametros.fnHuellaValida(mensajeResp);
                    objServerHuella.clearInterval();
                }

             }else

             if (mensajeResp.codigoRespuesta == objServerHuella.respuesta.huellaInvalida) {
                if( $('#'+objServerHuella.buttonStatusID).is(':visible')) {
                    objServerHuella.clearInterval();
                    objServerHuella.parametros.fnHuellaInvalida(mensajeResp);
                    objServerHuella.operacionEnProceso = false;
                }
             }else

             if (mensajeResp.codigoRespuesta == objServerHuella.respuesta.enrolamientoTerminado) {
                if( $('#'+objServerHuella.buttonStatusID).is(':visible')) {
                    objServerHuella.clearInterval();
                    desbloquearPantalla();
                    if(objServerHuella.numeroHuellasRegistradas>0){
                        mensajeResp.mensajeRespuesta = mensajeResp.mensajeRespuesta+"<br>"+
                                      "Las Huellas Registradas no podrán ser utilizadas hasta ser autorizadas por el proceso automático de validación de duplicidad.";
                    }
                    objServerHuella.parametros.fnGrabarHuella(mensajeResp);
                }
             }else

             if (mensajeResp.codigoRespuesta == objServerHuella.respuesta.grabarHuella) {
                desbloquearPantalla();
                objServerHuella.grabaHuella(mensajeResp);
             }else

             if (mensajeResp.codigoRespuesta != "000" & mensajeResp.codigoRespuesta != "400" ){
                if( $('#'+objServerHuella.buttonStatusID).is(':visible')) {
                     mensajeSis(mensajeResp.mensajeRespuesta);
                }
             }

        };


}

HuellaServer.prototype.cerrarConexion = function(){
        if( typeof this.webSocket == 'object'){
            this.webSocket.close();
        }
        this.operacionEnProceso = false;
}

HuellaServer.prototype.iniciaTimeOut = function(){

        timeDateServerHuella = new Date();
        timeDateServerHuella.setMinutes(timeDateServerHuella.getMinutes() + 5);

        checkTimeServerHuella = setInterval(function(){
            var now = new Date().getTime();
            var distance = timeDateServerHuella - now;
            var days = Math.floor(distance / (1000 * 60 * 60 * 24));
            var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);


            timeOutServerHuella += 1;

            $('#timerSrvHuella').html( "0" + minutes + ":" + (seconds < 10 ? "0" + seconds : seconds ) );

            if(timeOutServerHuella >= 180){
                objServerHuella.stopTimeOut();
                return false;
            }

        },1000);
}

HuellaServer.prototype.stopTimeOut = function(){

    var mensajeResp = {
            codigoRespuesta : '999',
            mensajeRespuesta: 'Se ha agotado el tiempo de espera para validar la huella del cliente'
        }

        objServerHuella.clearInterval();
        objServerHuella.inicializarInterfazHuella();
        objServerHuella.parametros.fnHuellaInvalida(mensajeResp);

        return false;
}

HuellaServer.prototype.clearInterval = function(){
        timeOutServerHuella = 0;
        clearInterval(checkTimeServerHuella);
}


HuellaServer.prototype.reConectarSocket = function(){
         if(  this.webSocket != null){
            this.webSocket.close();
        }
        this.iniciarConexion();
}


HuellaServer.prototype.envioMensajeSocket = function(mensajeBean){
        this.webSocket.send(JSON.stringify(mensajeBean));
}


/*
Metodo para asignar un nuevo enrolamiento de cliente y enviar los
datos del primer firmante
*/
HuellaServer.prototype.enrolamientoCliente = function(nomCliente,idCuenta, nomCta, personaID, dedoHuellaUno, dedoHuellaDos ){


    this.bloqueaPantalla('Se ha iniciado el proceso para '+this.tipoRegistroHuella+' las huellas del Cliente');

    this.inicializarInterfazHuella();

    $('#footerSrvHuella').append(this.btnCancelar);
    $('#btnHuellaCancelar').html("Cancelar Enrolamiento");
    $('#btnHuellaCancelar').click(function(event){
        objServerHuella.cancelarOperacionActual();
    });

    $('#timerSrvHuella').hide();

    var mensajeBean = {
        tipoMetodo: this.metodo.enrolamientoCliente,
        nombreCliente: nomCliente,
        numeroCuenta: idCuenta,
        tipoCuenta: nomCta,

        /* Firmante */
        personaID: personaID,
        dedoHuellaUno: dedoHuellaUno ,
        dedoHuellaDos: dedoHuellaDos,
    }

    this.operacionEnProceso = true;
    this.envioMensajeSocket(mensajeBean);
}

/*
Metodo para asignar un nuevo enrolamiento de Usuario
*/
HuellaServer.prototype.enrolamientoUsuario = function(nomCliente,idCuenta, nomCta, personaID, dedoHuellaUno, dedoHuellaDos ){


    this.bloqueaPantalla('Se ha iniciado el proceso para '+this.tipoRegistroHuella+' las huellas del Usuario');

    this.inicializarInterfazHuella();

    $('#footerSrvHuella').append(this.btnCancelar);
    $('#btnHuellaCancelar').html("Cancelar Enrolamiento");
    $('#btnHuellaCancelar').click(function(event){
        objServerHuella.cancelarOperacionActual();
    });

    $('#timerSrvHuella').hide();

    var mensajeBean = {
        tipoMetodo: this.metodo.enrolamientoUsuario,
        nombreCliente: nomCliente,
        numeroCuenta: idCuenta,
        tipoCuenta: nomCta,

        /* Firmante */
        personaID: personaID,
        dedoHuellaUno: dedoHuellaUno ,
        dedoHuellaDos: dedoHuellaDos,
    }

    this.operacionEnProceso = true;
    this.envioMensajeSocket(mensajeBean);
}

/*
Metodo para asignar un nuevo enrolamiento de cliente y enviar los
datos del primer firmante
*/
HuellaServer.prototype.enrolamientoCuenta = function(nomCliente,idCuenta, nomCta, personaID, dedoHuellaUno, dedoHuellaDos, tipoPersona ){

    this.bloqueaPantalla('Se ha iniciado el proceso para '+this.tipoRegistroHuella+' las huellas de los Firmantes');

    this.inicializarInterfazHuella();

    $('#timerSrvHuella').hide();

    $('#footerSrvHuella').append(this.btnCancelar);
    $('#btnHuellaCancelar').html("Cancelar Enrolamiento");
    $('#btnHuellaCancelar').click(function(event){
        objServerHuella.cancelarOperacionActual();
    });

    var mensajeBean = {
        tipoMetodo: this.metodo.enrolamientoCuenta,
        nombreCliente: nomCliente,
        numeroCuenta: idCuenta,
        tipoCuenta: nomCta,
        tipoPersona: tipoPersona,

        /* Firmante */
        personaID: personaID,
        dedoHuellaUno: dedoHuellaUno ,
        dedoHuellaDos: dedoHuellaDos,
    }

    this.operacionEnProceso = true;
    this.envioMensajeSocket(mensajeBean);
}


// Metodo para asignar un nuevo enrolamiento del usuario de servicios.
HuellaServer.prototype.enrolamientoUsuarioServicios = function(nombreUsuario, idCuenta, nomCta, personaID, dedoHuellaUno, dedoHuellaDos){

    this.bloqueaPantalla('Se ha iniciado el proceso para '+this.tipoRegistroHuella+' las huellas del Usuario de servicios.');

    this.inicializarInterfazHuella();

    $('#footerSrvHuella').append(this.btnCancelar);
    $('#btnHuellaCancelar').html("Cancelar Enrolamiento");
    $('#btnHuellaCancelar').click(function(event){
        objServerHuella.cancelarOperacionActual();
    });

    $('#timerSrvHuella').hide();

    var mensajeBean = {
        tipoMetodo: this.metodo.enrolamientoUsuarioServicios,
        nombreCliente: nombreUsuario,
        numeroCuenta: idCuenta,
        tipoCuenta: nomCta,

        // Firmante
        personaID: personaID,
        dedoHuellaUno: dedoHuellaUno ,
        dedoHuellaDos: dedoHuellaDos,
    }

    this.operacionEnProceso = true;
    this.envioMensajeSocket(mensajeBean);
}

/*
*  Metodo para establecer el modo de validación de huella,
*  Se envia al primer firmate de la lista.
*/

HuellaServer.prototype.validaHuellaVentanilla = function(nomCliente,    tipoPersona,    idCuenta,
                                                        nomCta,         personaID,     dedoHuellaUno,
                                                        dedoHuellaDos,  byteHuellaUno, byteHuellaDos
                                                         ){

    var mensajeBean = {
        tipoMetodo      : this.metodo.validaHuellaVentanilla,
        nombreCliente   : nomCliente,
        numeroCuenta    : idCuenta,
        tipoCuenta      : nomCta,
        tipoPersona     : tipoPersona,

        /* Firmante */
        personaID       : personaID,
        dedoHuellaUno   : dedoHuellaUno ,
        dedoHuellaDos   : dedoHuellaDos,
        byteHuellaUno   : byteHuellaUno ,
        byteHuellaDos   : byteHuellaDos
    }

    this.operacionEnProceso = true;
    this.envioMensajeSocket(mensajeBean);
}


/*
*  Metodo para establecer el modo de validación de huella,
*  Para el login y autorización de Pantallas
*/
HuellaServer.prototype.validaHuellaUsuario= function(nomCliente,    idCuenta,       nomCta,
                                                         personaID,     dedoHuellaUno,  dedoHuellaDos,
                                                         byteHuellaUno, byteHuellaDos
                                                         ){

    var mensajeBean = {
        tipoMetodo      : this.metodo.validaHuellaUsuario,
        nombreCliente   : nomCliente,
        numeroCuenta    : idCuenta,
        tipoCuenta      : nomCta,

        /* Firmante */
        personaID       : personaID,
        dedoHuellaUno   : dedoHuellaUno ,
        dedoHuellaDos   : dedoHuellaDos,
        byteHuellaUno   : byteHuellaUno ,
        byteHuellaDos   : byteHuellaDos
    }

    this.operacionEnProceso = true;
    this.envioMensajeSocket(mensajeBean);
}

/* Inicializar interfaz de huella para nueva transaccion */
HuellaServer.prototype.inicializarInterfazHuella = function(){

	this.numeroHuellasRegistradas = 0;

    var mensajeBean = {
        tipoMetodo: this.metodo.cancelarOperacionActual,
    }

    this.envioMensajeSocket(mensajeBean);

}


/*
* Cancela la operación actual para reiniciar la interfaz del jar de huella
 */
HuellaServer.prototype.cancelarOperacionActual = function(){

    var mensajeBean = {
        tipoMetodo: this.metodo.cancelarOperacionActual,
    }

    this.envioMensajeSocket(mensajeBean);

    if(this.numeroHuellasRegistradas>0){
        mensajeSis("Las Huellas Registradas no podrán ser utilizadas hasta ser autorizadas por el proceso automático de validación de duplicidad.");
    }else{
        desbloquearPantalla();
    }

    clearInterval(checkTimeServerHuella);
    this.timeOutServerHuella = 0;
    this.operacionEnProceso = false;
    this.reConectarSocket();


}


/*
*  Graba la huella que recibe del socket
*/
HuellaServer.prototype.grabaHuella = function(huellaDigital) {
        var parametroBeanHuella = consultaParametrosSession();

        var permiteContrasenia ="N";
        if($('#'+objServerHuella.buttonStatusID).is(':visible')){
            bloquearPantalla();
        }

        var huellaDigitalBean ={
                'tipoPersona' : huellaDigital.tipoPersona,
                'personaID' : huellaDigital.idPersona,
                'manoSeleccionada' : huellaDigital.manoSeleccion,
                'dedoSeleccionado' : huellaDigital.dedoSeleccion,
                'huella' : huellaDigital.ultimaHuellaCapturada,
                'fidImagenHuella': huellaDigital.fidImagenHuella,
                'sucursalID': parametroBeanHuella.sucursal,
                'usuarioID': parametroBeanHuella.numeroUsuario

        };

        huellaDigitalServicio.grabaTransaccion(this.GRABAR_HUELLA, huellaDigitalBean, function(mensajeTransaccion){
              var mensajeRespuesta;
              if($('#'+objServerHuella.buttonStatusID).is(':visible')) {
                  if (mensajeTransaccion != null) {

                        if(mensajeTransaccion.numero != 0){
                            objServerHuella.bloqueaPantalla(mensajeTransaccion.descripcion);
                        }else{
                        	objServerHuella.numeroHuellasRegistradas++;
                            objServerHuella.bloqueaPantalla('Se ha grabado correctamente la Huella de la Mano '+
                                                 objServerHuella.Mano[huellaDigitalBean.manoSeleccionada] +
                                                 ".<br>Continúe con el Proceso de Enrolamiento.");
                        }

                  }else{

                      objServerHuella.bloqueaPantalla('La Huella Digital no pudo Ser Registrada en SAFI.'+
                                                 "<br>Intente nuevamente.");

                  }
              }

              $('#footerSrvHuella').append(objServerHuella.btnCancelar);
              $('#btnHuellaCancelar').html("Cancelar Enrolamiento");
              $('#btnHuellaCancelar').click(function(event){
                    objServerHuella.cancelarOperacionActual();
              });

              $('#timerSrvHuella').hide();


        });
    }

/*
* Envia la información de los firmantes a registrar o validar
 */
HuellaServer.prototype.cargaFirmantes = function(nomCliente,nomCta, personaID, dedoHuellaUno,
                                                    dedoHuellaDos,  byteHuellaUno, byteHuellaDos){

         var mensajeBean = {
            tipoMetodo : this.metodo.cargaFirmante,
            nombreCliente: nomCliente,
            tipoPersona: nomCta,

            /* Firmante */
            personaID: personaID,
            dedoHuellaUno: dedoHuellaUno ,
            dedoHuellaDos: dedoHuellaDos,
            byteHuellaUno: byteHuellaUno ,
            byteHuellaDos: byteHuellaDos

         }
         this.envioMensajeSocket(mensajeBean);
}


/* Valida si se debe llamar a los firmantes o solo a las huellas del cliente */
HuellaServer.prototype.muestraFirma = function(){

            if(!this.estaConectado){
                mensajeSis("La aplicación de Huella Digital no se está ejecutando en este equipo."+
                             " Revise que la aplicación se encuentre activa y vuelva a intentarlo");
                return false;
            }

            /* Validar si la operacion requiere Huella Digital */
            if ( objServerHuella.noRequiereHuellaFn( $('#tipoOperacion').asNumber() ) ) {
                var mensajeResp = {codigoRespuesta :'200', mensajeRespuesta: 'No requiere autorización con Huella'};
                objServerHuella.parametros.fnHuellaValida(mensajeResp);
                objServerHuella.clearInterval();
                return false;
            }


            this.bloqueaPantalla('Es necesario autorizar la Transacción con la huella del cliente.');
            this.inicializarInterfazHuella();

            $('#footerSrvHuella').append(this.btnCancelar);
            $('#btnHuellaCancelar').click(function(event){
                objServerHuella.cancelarOperacionActual();
            });

            this.iniciaTimeOut();

            idCuenta=this.ctaOperacion();

            var tipConCampos= 4;
            var CuentaAhoBeanCon = {
                    'cuentaAhoID'   :idCuenta,
                    'clienteID':''
                };

            /*
            * Validar si se trata de una operación sobre la cuenta de ahorro
             */
            if(this.tipoInstrumento == this.catInstrumento.CUENTA) {
                    cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
                            if(cuenta!=null){

                                clienteServicio.consulta(1,cuenta.clienteID,function(cliente) {

                                    objServerHuella.funcionMostrarFirmaCuentas(
                                                                    idCuenta,
                                                                    cliente.nombreCompleto,
                                                                    cuenta.descripcionTipoCta
                                                                );


                                });

                            }else{
                               mensajeSis('La Cuenta ingresada no existe');
                               timeOutServerHuella = 0;
                               clearInterval(checkTimeServerHuella);
                               return false;
                            }
                    });
            }

            /*
            * Validar si se trata de una operación del cliente
             */
            if(this.tipoInstrumento == this.catInstrumento.CLIENTE) {

                clienteServicio.consulta(1,idCuenta,function(cliente) {
                    objServerHuella.funcionMostrarFirmaCliente(
                                                cliente.nombreCompleto,
                                                idCuenta
                                            );
                });
            }

}

// Validaciones para ejecutar funcion que mostrará huellas del usuario se servicios.
HuellaServer.prototype.muestraFirmaUsuarioServicios = function() {

    if (!this.estaConectado) {
        mensajeSis("La aplicación de Huella Digital no se está ejecutando en este equipo." +
            " Revise que la aplicación se encuentre activa y vuelva a intentarlo");
        return false;
    }

    var tipoOperacion = +$('#tipoOperacion').val().replace(/\s/g, '');

    // Validar si la operacion requiere Huella Digital.
    if (!(tipoOperacion in objServerHuella.requiereHuellaUsuarioServ)) {
        var mensajeResp = { codigoRespuesta: '200', mensajeRespuesta: 'No requiere autorización con Huella' };
        objServerHuella.parametros.fnHuellaValida(mensajeResp);
        objServerHuella.clearInterval();
        return false;
    }

    this.bloqueaPantalla('Es necesario autorizar la Transacción con la huella del usuario de servicios.');
    this.inicializarInterfazHuella();

    $('#footerSrvHuella').append(this.btnCancelar);
    $('#btnHuellaCancelar').click(function(event){
        objServerHuella.cancelarOperacionActual();
    });

    this.iniciaTimeOut();

    var usuarioID = this.usuarioServIDOperacion(tipoOperacion);

    usuarioServicios.consulta(1, { 'usuarioID': usuarioID }, function (usuario) {

        if (usuario != null) {
            objServerHuella.funcionMostrarFirmaUsuarioServ(
                usuario.usuarioID
            );
        } else {
            mensajeSis('El usuario de servicios ingresado no existe.');
            timeOutServerHuella = 0;
            clearInterval(checkTimeServerHuella);
            return false;
        }
    });
}

/* Valida si se debe llamar a los firmantes o solo a las huellas del cliente en pantallas*/
HuellaServer.prototype.muestraFirmaAutorizacion = function(){

    if(!this.estaConectado){
        mensajeSis("La aplicación de Huella Digital no se está ejecutando en este equipo."+
                     " Revise que la aplicación se encuentre activa y vuelva a intentarlo");
        return false;
    }

    this.bloqueaPantalla('Es necesario autorizar la Transacción con la huella del cliente.');
    this.inicializarInterfazHuella();

    $('#footerSrvHuella').append(this.btnCancelar);
    $('#btnHuellaCancelar').click(function(event){
        objServerHuella.cancelarOperacionActual();
    });

    this.iniciaTimeOut();

    idCuenta=this.obtenerDatosPantalla();
    var tipConCampos= 4;
    var CuentaAhoBeanCon = {
            'cuentaAhoID'   :idCuenta,
            'clienteID':''
        };
    /*
    * Validar si se trata de una operación sobre la cuenta de ahorro
     */
    if(this.tipoInstrumento == this.catInstrumento.CUENTA) {
        cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
            if(cuenta!=null){

                clienteServicio.consulta(1,cuenta.clienteID,function(cliente) {
                    objServerHuella.funcionMostrarFirmaCuentas( idCuenta, cliente.nombreCompleto, cuenta.descripcionTipoCta);
                });

            }else{
                mensajeSis('La Cuenta ingresada no existe');
                timeOutServerHuella = 0;
                clearInterval(checkTimeServerHuella);
                return false;
            }
        });
    }

    /*
    * Validar si se trata de una operación del cliente
     */
    if(this.tipoInstrumento == this.catInstrumento.CLIENTE) {
        clienteServicio.consulta(1,idCuenta,function(cliente) {
            objServerHuella.funcionMostrarFirmaCliente( cliente.nombreCompleto, idCuenta);
        });
    }

}

HuellaServer.prototype.funcionMostrarFirmaCuentas = function(idCuenta,nomCliente,nomCta){
            var firmanteBeanCon = {
                    'cuentaAhoID' : idCuenta
            };

            cuentasFirmaServicio.listaHuellasCombo(this.catListaCombo.combo, firmanteBeanCon, function(firmantesLista){
                  if(firmantesLista != null && firmantesLista.length > 0){

                        var Verificacion='VERIFICACION';

                        for (var i = 0; i < firmantesLista.length; i++){

                            /*
                            * Se envia el primer firmante para establecer el modo de validación de huella
                             */
                            if( i == 0){
                                objServerHuella.validaHuellaVentanilla(
                                                    firmantesLista[i].nombreCompleto,
                                                    firmantesLista[i].tipoFirmante,
                                                    idCuenta,
                                                    nomCta,
                                                    firmantesLista[i].personaID,
                                                    firmantesLista[i].dedoHuellaUno,
                                                    firmantesLista[i].dedoHuellaDos,
                                                    firmantesLista[i].huellaUno,
                                                    firmantesLista[i].huellaDos
                                                );

                            }else{
                                 objServerHuella.cargaFirmantes(
                                                    firmantesLista[i].nombreCompleto,
                                                    firmantesLista[i].tipoFirmante,
                                                    firmantesLista[i].personaID,
                                                    firmantesLista[i].dedoHuellaUno,
                                                    firmantesLista[i].dedoHuellaDos,
                                                    firmantesLista[i].huellaUno,
                                                    firmantesLista[i].huellaDos
                                                );
                            }



                        }

                  }else{
                      mensajeSis("La Cuenta No tiene Firmantes Favor de Verificar");
                      timeOutServerHuella = 0;
                      clearInterval(checkTimeServerHuella);
                      return false;
                  }
             });

        }

HuellaServer.prototype.funcionMostrarFirmaCliente = function(nomCliente,idCuenta){
        var IDCta='N/A';
        var nomCta="";
        var TipoPersona="C";

        var CteBeanCon = {
                'personaID' : idCuenta
        };

        huellaDigitalServicio.listaHuellasCombo(4, CteBeanCon, function(firmantesLista){
            if(firmantesLista != null && firmantesLista.length > 0){

                  var Verificacion='VERIFICACION';
                  for (var i = 0; i < firmantesLista.length; i++){

                      /*
                      * Se envia el primer firmante para establecer el modo de validación de huella
                       */
                      if( i == 0){
                          objServerHuella.validaHuellaVentanilla(
                                              firmantesLista[i].nombreCompleto,
                                              firmantesLista[i].tipoPersona,
                                              IDCta,
                                              nomCta,
                                              firmantesLista[i].personaID,
                                              firmantesLista[i].dedoHuellaUno,
                                              firmantesLista[i].dedoHuellaDos,
                                              firmantesLista[i].huellaUno,
                                              firmantesLista[i].huellaDos
                                          );

                      }else{

                           objServerHuella.cargaFirmantes(
                                              firmantesLista[i].nombreCompleto,
                                              firmantesLista[i].tipoPersona,
                                              firmantesLista[i].personaID,
                                              firmantesLista[i].dedoHuellaUno,
                                              firmantesLista[i].dedoHuellaDos,
                                              firmantesLista[i].huellaUno,
                                              firmantesLista[i].huellaDos
                                          );
                      }



                  }

            }else{
                mensajeSis("La Cuenta No tiene Firmantes Favor de Verificar");
                timeOutServerHuella = 0;
                clearInterval(checkTimeServerHuella);
                return false;
            }
       });

    }

HuellaServer.prototype.funcionMostrarFirmaUsuario = function(nomUsuario, numUsuario,huella_OrigenDatos,bloqPantalla){
        if(!this.estaConectado){
            mensajeSis("La aplicación de Huella Digital no se está ejecutando en este equipo."+
                         " Revise que la aplicación se encuentre activa y vuelva a intentarlo");
            return false;
        }

        if(typeof bloqPantalla == 'undefined'){
            this.bloqueaPantalla('Es necesario autorizar la Transacción con la huella del Usuario:'+nomUsuario);
        }

        $('#footerSrvHuella').append(this.btnCancelar);
        $('#btnHuellaCancelar').click(function(event){
            objServerHuella.cancelarOperacionActual();
        });

        this.iniciaTimeOut();

        this.tipoInstrumento = this.catInstrumento.USUARIO;

        var IDCta='N/A';
        var nomCta="";
        var TipoPersona="U";

        var CteBeanCon = {
                'personaID' : numUsuario,
                'origenDatos' : huella_OrigenDatos
        };

        huellaDigitalServicio.consulta(2, CteBeanCon, function(CteBean){

            if (CteBean != null){
                var Verificacion='VERIFICACION';

                objServerHuella.validaHuellaUsuario(    nomUsuario,
                                                        IDCta,
                                                        nomCta,
                                                        CteBean.personaID,
                                                        CteBean.dedoHuellaUno,
                                                        CteBean.dedoHuellaDos,
                                                        CteBean.huellaUno,
                                                        CteBean.huellaDos
                                                        );


            }else{
               mensajeSis("El Usuario no tiene registrada sus huellas.");
               timeOutServerHuella = 0;
                clearInterval(checkTimeServerHuella);
                return false;
            }
         });

    }

// 	función para consultar las huellas del usuario de servicios y/o firmante(s).
HuellaServer.prototype.funcionMostrarFirmaUsuarioServ = function (usuarioID) {
    var IDCta = 'N/A';
    var nomCta = "";

    huellaDigitalServicio.listaHuellasCombo(5, { 'personaID': usuarioID }, function (firmantesLista) {

        if (firmantesLista != null && firmantesLista.length > 0) {

            for (var i = 0; i < firmantesLista.length; i++) {


                // Se envia el primer firmante para establecer el modo de validación de huella.
                if (i == 0) {
                    objServerHuella.validaHuellaVentanilla(
                        firmantesLista[i].nombreCompleto,
                        firmantesLista[i].tipoPersona,
                        IDCta,
                        nomCta,
                        firmantesLista[i].personaID,
                        firmantesLista[i].dedoHuellaUno,
                        firmantesLista[i].dedoHuellaDos,
                        firmantesLista[i].huellaUno,
                        firmantesLista[i].huellaDos
                    );
                } else {
                    objServerHuella.cargaFirmantes(
                        firmantesLista[i].nombreCompleto,
                        firmantesLista[i].tipoPersona,
                        firmantesLista[i].personaID,
                        firmantesLista[i].dedoHuellaUno,
                        firmantesLista[i].dedoHuellaDos,
                        firmantesLista[i].huellaUno,
                        firmantesLista[i].huellaDos
                    );
                }
            }

        } else {
            mensajeSis("El usuario de servicios no tiene registrada sus huellas y tampoco cuenta con firmantes.");
            timeOutServerHuella = 0;
            clearInterval(checkTimeServerHuella);
            return false;
        }
    });
}


HuellaServer.prototype.ctaOperacion = function(){
                NumeroCta='';

                this.bitacoraBean.tipoOperacion =  $('#tipoOperacion').val();
                this.bitacoraBean.descriOperacion =  $('#tipoOperacion option:selected').text();

                switch($('#tipoOperacion').asNumber()){
                    case this.operacionesVentanilla.retiroEfectivo :
                        NumeroCta=$('#cuentaAhoIDCa').val();
                        this.bitacoraBean.clienteUsuario = $('#numClienteCa').val();
                        this.tipoInstrumento = this.catInstrumento.CUENTA;
                    break;
                    case this.operacionesVentanilla.devolucionGarLiq:
                        NumeroCta=$('#cuentaAhoIDDG').val();
                        this.bitacoraBean.clienteUsuario = $('#numClienteDG').val();
                        this.tipoInstrumento = this.catInstrumento.CUENTA;
                    break;
                    case this.operacionesVentanilla.desemboCred :
                        NumeroCta=$('#cuentaAhoIDDC').val();
                        this.bitacoraBean.clienteUsuario = $('#clienteIDDC').val();
                        this.tipoInstrumento = this.catInstrumento.CUENTA;
                    break;
                    case this.operacionesVentanilla.tranferenciaCuenta :
                        NumeroCta=$('#cuentaAhoIDT').val();
                        this.bitacoraBean.clienteUsuario = $('#numClienteT').val();
                        this.tipoInstrumento = this.catInstrumento.CUENTA;
                    break;

                    case this.operacionesVentanilla.devAportacionSocial :
                        NumeroCta=$('#clienteIDDAS').val(); //Se utiliza al cliente ya que en la pantalla no se muestra la cuenta
                        this.bitacoraBean.clienteUsuario = '';
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.aplicaSegVidaAyuda :
                        NumeroCta=$('#clienteIDASVA').val();//Se utiliza al cliente ya que en la pantalla no se muestra la cuenta
                        this.bitacoraBean.clienteUsuario = $('#clienteIDASVA').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;
                    case this.operacionesVentanilla.pagoServifun :
                        NumeroCta=$('#clienteServifunID').val();//
                        this.bitacoraBean.clienteUsuario = $('#clienteServifunID').val();;
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;
                    case this.operacionesVentanilla.haberesExmenor :
                        NumeroCta=$('#clienteIDMenor').val();//Se utiliza al cliente ya que en la pantalla no se muestra la cuenta
                        this.bitacoraBean.clienteUsuario = $('#clienteIDMenor').val();;
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.cobroApoyoEscolar :
                        NumeroCta=$('#clienteIDApoyoEsc').val();//Se utiliza al cliente ya que en la pantalla no se muestra la cuenta
                        this.bitacoraBean.clienteUsuario = $('#clienteIDApoyoEsc').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.abonoCuenta  :
                        NumeroCta = $('#cuentaAhoIDAb').val();
                        this.bitacoraBean.clienteUsuario = $('#numClienteAb').val();
                        this.tipoInstrumento = this.catInstrumento.CUENTA;
                    break;

                    case this.operacionesVentanilla.pagoCredito  :
                        NumeroCta = $('#clienteID').val();
                        this.bitacoraBean.clienteUsuario = $('#clienteID').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.depGarantiLiquida  :
                        NumeroCta = $('#numClienteGL').val();
                        this.bitacoraBean.clienteUsuario = $('#numClienteGL').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.comAperturaCred  :
                        NumeroCta = $('#clienteIDAR').val();
                        this.bitacoraBean.clienteUsuario = $('#clienteIDAR').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.cobroPolizaCobRiesgo  :
                        NumeroCta = $('#clienteIDSC').val();
                        this.bitacoraBean.clienteUsuario = $('#clienteIDSC').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;



                    case this.operacionesVentanilla.cobSeguroVidaAyuda  :
                        NumeroCta = $('#clienteIDCSVA').val();
                        this.bitacoraBean.clienteUsuario = $('#clienteIDCSVA').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;


                    case this.operacionesVentanilla.prepagoCredito  :
                        NumeroCta = $('#clienteIDPre').val();
                        this.bitacoraBean.clienteUsuario = $('#clienteIDPre').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.pagoServicios  :
                        NumeroCta = $('#clienteIDCobroServ').val();
                        this.bitacoraBean.clienteUsuario = $('#clienteIDCobroServ').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.recCarteraCastigada  :
                        NumeroCta = $('#clienteIDVencido').val();
                        this.bitacoraBean.clienteUsuarioCLIENTE = $('#clienteIDVencido').val();
                        this.tipoInstrumento = this.catInstrumento.CLIENTE;
                    break;

                    case this.operacionesVentanilla.transferenciaInterna  :
                        NumeroCta = $('#cuentaAhoIDT').val();
                        this.bitacoraBean.clienteUsuario = $('#numClienteT').val();
                        this.tipoInstrumento = this.catInstrumento.CUENTA;
                     break;

                }

                return NumeroCta;
            }

// función para obtener el ID del usuario de servicios dependiendo del tipo de operación.
HuellaServer.prototype.usuarioServIDOperacion = function (tipoOperacion) {

    var usuarioServicioID = '';

    switch (tipoOperacion) {

        case this.operacionesVentanilla.pagoRemesas:
            usuarioServicioID = $('#usuarioRem').val();
        break;
    }

    return usuarioServicioID;
}

HuellaServer.prototype.obtenerDatosPantalla = function(){
    NumeroCta='';
    this.bitacoraBean.tipoOperacion =  $('#tipoOperacion').val();
    this.bitacoraBean.descriOperacion = "";
    switch($('#tipoOperacion').asNumber()){
	    case this.autorizacionPantalla.autorizacionInversion :
	        NumeroCta=$('#cuentaAhoID').val();
	        this.bitacoraBean.clienteUsuario = $('#clienteID').val();
	        this.tipoInstrumento = this.catInstrumento.CUENTA;
	        this.bitacoraBean.descriOperacion = "AUTORIZACIÓN DE INVERSIÓN";
	    break;
	    case this.autorizacionPantalla.cancelacionInversion :
	        NumeroCta=$('#cuentaAhoID').val();
	        this.bitacoraBean.clienteUsuario = $('#clienteID').val();
	        this.tipoInstrumento = this.catInstrumento.CUENTA;
	        this.bitacoraBean.descriOperacion = "CANCELACION DE INVERSIÓN";
	    break;
	    case this.autorizacionPantalla.reinversionInversion :
	        NumeroCta=$('#cuentaAhoID').val();
	        this.bitacoraBean.clienteUsuario = $('#clienteID').val();
	        this.tipoInstrumento = this.catInstrumento.CUENTA;
	        this.bitacoraBean.descriOperacion = "REINVERSIÓN";
	    break;
	    case this.autorizacionPantalla.vencimientoInversion :
	        NumeroCta=$('#cuentaAhoID').val();
	        this.bitacoraBean.clienteUsuario = $('#clienteID').val();
	        this.tipoInstrumento = this.catInstrumento.CUENTA;
	        this.bitacoraBean.descriOperacion = "VENCIMIENTO ANTICIPADO DE INVERSIÓN";
	    break;
	    case this.autorizacionPantalla.desembolsoCredito :
	        NumeroCta=$('#cuentaID').val();
	        this.bitacoraBean.clienteUsuario = $('#clienteID').val();
	        this.tipoInstrumento = this.catInstrumento.CUENTA;
	        this.bitacoraBean.descriOperacion = "DESEMBOLSO DE CRÉDITO";
        break;
        case this.autorizacionPantalla.envioSpei :
	        NumeroCta=$('#cuentaAhoID').val();
	        this.bitacoraBean.clienteUsuario = $('#clienteID').val();
	        this.tipoInstrumento = this.catInstrumento.CUENTA;
	        this.bitacoraBean.descriOperacion = "Envío SPEI";
	    break;
    }

    return NumeroCta;
}

HuellaServer.prototype.registroBitacora = function(numTransaccion,funcionCallbak){
    objServerHuella.bitacoraBean.numeroTransaccion = numTransaccion;
    objServerHuella.bitacoraBean.fecha = objServerHuella.getFechaActual();
    objServerHuella.bitacoraBean.clienteUsuario     = mensajeResp.usuarioID;
    objServerHuella.bitacoraBean.tipo               = mensajeResp.tipoPersona;
    if(objServerHuella.operacionEnProceso){
        $.ajax(
            {   type: "POST",
                url: "bitacoraHuella.htm",
                data: objServerHuella.bitacoraBean,
                success: function(mensajeBean) {
                    if( typeof funcionCallbak == 'function' ){
                        funcionCallbak(mensajeBean);
                    }
                }
        });
        objServerHuella.operacionEnProceso = false;
    }

}

HuellaServer.prototype.registroBitacoraUsuario = function(mensaje, tipoOperacion,usuarioID, numTransaccion,funcionCallbak){

    objServerHuella.bitacoraBean.numeroTransaccion  = numTransaccion;
    objServerHuella.bitacoraBean.fecha              = objServerHuella.getFechaActual();
    objServerHuella.bitacoraBean.tipoOperacion      = tipoOperacion,
    objServerHuella.bitacoraBean.descriOperacion    = mensaje;
    objServerHuella.bitacoraBean.tipo               =  'U';
    objServerHuella.bitacoraBean.clienteUsuario     = usuarioID;

    $.ajax(
        {   type: "POST",
            url: "bitacoraHuella.htm",
            data: objServerHuella.bitacoraBean,
            success: function(mensajeBean) {
                if( typeof funcionCallbak == 'function' ){
                    funcionCallbak(mensajeBean);
                }
            }
    });

    objServerHuella.operacionEnProceso = false;

}

HuellaServer.prototype.bloqueaPantalla = function(mensajeHuella){

        $('#contenedorForma').block({
            message: this.mensajeHuella,
            css: {border:       'none',
                background: 'none'}
        });

        $('#mensajeContenido').html(mensajeHuella);

}

HuellaServer.prototype.getFechaActual = function(){
    var f = new Date();
    return f.getFullYear() + "-" + ( (f.getMonth() +1) < 10 ? "0" : "") +  (f.getMonth() +1) + "-" + ( f.getDate() < 10 ? "0" : "" )+ f.getDate();
}

HuellaServer.prototype.noRequiereHuellaFn = function (valor){
    for(var i=0; i< this.noRequiereHuella.length ; i++){
        if (valor == this.noRequiereHuella[i]){
            return true;
        }
    }

    return false;
}