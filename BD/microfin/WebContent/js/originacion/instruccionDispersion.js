var catTipoConsultaSolicitud = {
'dispersion' : 17
};
parametros = consultaParametrosSession();
var usuario = parametros.numeroUsuario;
var solicitudEstatus="";
var instrucccionesEstatus="";
var perfilAnalista="";
var segrabo=false;
var botonHabilitado = "";
$('#solicitudCreditoID').focus();   

$(document).ready(function() {
            esTab = true;
            inicializarPantalla();

            $(':text').bind('keydown', function(e) {
                if (e.which == 9 && !e.shiftKey) {
                    esTab = true;
                }
            });

            $(':text').focus(function() {
                esTab = false;
            });

});

function inicializarPantalla(){
    $('#solicitudCreditoID').focus();   
    $('#divGridInstruccion').html("");
    $('#divGridInstruccion').hide();
    esTab = true;
    deshabilitaBoton('autorizarInstruccion', 'submit');
    //  ------------ Metodos y Manejo de Eventos Solicitud Grupal -----------------------------------------
    agregaFormatoControles('formaGenerica');
    consultaPerfilAnalista();
    validaFlujoIndividual();
    
}
//consulta el perfil del analista
function consultaPerfilAnalista(){
        var consultaPerfil = 1;
        var consultaPerfilEjecutivo = 2;
        var bean = {};
        perfilesAnalistasCreServicio.consulta(consultaPerfil,bean, function(perfilBean) {
            if(perfilBean != null){
                perfilAnalista=perfilBean.tipoPerfil;
                
            }else{
                perfilesAnalistasCreServicio.consulta(consultaPerfilEjecutivo,bean, function(perfilBeanE) {

                    if(perfilBeanE != null){

                        perfilAnalista=perfilBeanE.tipoPerfil;
                        
                    }else{
                        perfilAnalista="";
                    }
                });
                
            }
        });
        
}
$('#solicitudCreditoID').bind('keyup', function(e) {
    if (this.value.length >= 0) {
        var camposLista = new Array();
        var parametrosLista = new Array();

        camposLista[0] = "clienteID";
        parametrosLista[0] = $('#solicitudCreditoID').val();

        lista('solicitudCreditoID', '2', '20', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
    }
}); 
$('#solicitudCreditoID').blur(function() {
    if(segrabo){
        esTab=true;   
    }
    segrabo=false;
    if (esTab) {
    	obtienestatus();
        validaSolicitudCredito(this.id);
    }
});

//Bloque para consultar cliente si viene de flujo de consolidacion de créditos esta seccion se utiliza en flujo individual
function validaFlujoIndividual() {
    if ($('#flujoIndividualBandera').val() != undefined) {
      //Bloque para consultar cliente si viene de flujo de consolidacion de créditos
        if(typeof var_consolidacion !== 'undefined')
        {
            if(var_consolidacion.solicitudCreditoID != undefined)
            {
                $('#solicitudCreditoID').val(var_consolidacion.solicitudCreditoID);
                obtienestatus();
                validaSolicitudCredito('solicitudCreditoID');
            }
        }
    }
}
/* **************************** SOLICITUD DE CREDITO  ******************** */
function validaSolicitudCredito(idControl) {
    
    var jqSolicitud = eval("'#" + idControl + "'");
    var solCred = $(jqSolicitud).val();
    setTimeout("$('#cajaLista').hide();", 200);
    
    if (solCred != '' && !isNaN(solCred)) {
        inicializaForma('formaGenerica', 'solicitudCreditoID');
        var SolCredBeanCon = {
        'solicitudCreditoID' : solCred,
        'usuario' : usuario
        };
        bloquearPantalla();
        solicitudCredServicio.consulta(catTipoConsultaSolicitud.dispersion, SolCredBeanCon, {
        callback : function(solicitud) {
            if (solicitud != null && solicitud.solicitudCreditoID != 0) {
                
                $('#clienteID').val(solicitud.clienteID);
                $('#nombreCte').val(solicitud.nombreCompletoCliente);
                $('#montoSolici').val(solicitud.montoSolici);
                solicitudEstatus=solicitud.estatus;
                consultaGridInstruccionDispersionElegir();
                
                agregaFormatoControles('formaGenerica');
                desbloquearPantalla();
            } else {
                desbloquearPantalla();
                mensajeSis("La Solicitud de Credito No existe");
                $('#solicitudCreditoID').focus();
                $('#solicitudCreditoID').val("");
                inicializarPantalla();
            }
        },
        errorHandler : function(message) {
            mensajeSis("Error en Validacion de la Solicitud.<br>" + message);
            inicializarPantalla();
        }
        });
    }
}
/* **************************** Consulta Estatus ******************** */
function obtienestatus() {
    
  
    var solCred = $('#solicitudCreditoID').val();

    setTimeout("$('#cajaLista').hide();", 200);
    
    if (solCred != '' && !isNaN(solCred)) {
        inicializaForma('formaGenerica', 'solicitudCreditoID');
        var SolCredBeanCon = {
        'solicitudCreditoID' : solCred
        };
        bloquearPantalla();

        instruccionDispersionServicio.consulta(1, SolCredBeanCon, {
        callback : function(solicitud) {
            if (solicitud != null && solicitud.solicitudCreditoID != 0) {

               instrucccionesEstatus = solicitud.estatus ;
           
            } else {
                instrucccionesEstatus="";
                desbloquearPantalla();
            
            }
        },
        errorHandler : function(message) {
            mensajeSis("Error en Validacion de la instruccion de Disprsion.<br>" + message);
        }
        });
    }
}

function consultaGridInstruccionDispersionElegir(){    

    if(instrucccionesEstatus == "A" || instrucccionesEstatus == "R") {

        consultaGridInstruccionDispersion(); 
        
        setTimeout(function() { 
            agregaTotales();
         }, 2000);
    }else{
    	consultaGridInstruccionDispersion(); 
    }

}    
function consultaGridInstruccionDispersion(){           
    agregaFormatoControles('divGridInstruccion');
    var solicitudCreditoID=$('#solicitudCreditoID').val();
    var params = {};
    params['tipoLista'] = 1;//principal
    params['solicitudCreditoID'] = solicitudCreditoID;
     params['beneficiario'] = '';
    
    $.post("instruccionDispersionGrid.htm", params, function(data){
        
        if(data.length >0) {
            agregaFormatoControles('divGridInstruccion');
            $('#divGridInstruccion').html(data);

             
            $('#divGridInstruccion').show();
            $('#autorizarInstruccion').hide();

        $('.beneficiarioclass').bind('keyup', function(e) {
            if (this.value.length >= 0) {
                var camposLista = new Array();
                var parametrosLista = new Array();
                var numero = this.id.substring(14, 15);
                camposLista[0] = "clienteID";
                camposLista[1] = "tipoCtaBenSPEI";
                camposLista[2] = "tipoCuenta";
                

                parametrosLista[0] = $('#clienteID').val();
                parametrosLista[1] = $('#' + this.id).val();
                parametrosLista[2] = "E";
               

                lista(this.id, '2', '4', camposLista, parametrosLista, 'cuentasDestinoLista.htm');
            }
        });
        $('.beneficiarioclass').blur(function() {

                
                if (esTab) {
                    if($('#'+this.id).val()=="") {
                        var numero = this.id.substring(14, 15);
                        $('#cuentaID'+numero).val("");
                        $('#'+this.id).focus();
                        return false;
                }else if (!isNaN($('#'+this.id).val()))  {
                    validaCuenta(this.id);
                
                }else{
                    
                     var numero = this.id.substring(14, 15);
                     $('#cuentaID'+numero).val("");
                     $('#'+this.id).val("");
                     $('#cajaLista').hide();
                     mensajeSis("La Cuenta Clabe No Existe.");
                    
                    $('#'+this.id).focus();
                    
                }
            }
        });
            $("#numeroEsquema").val($('input[name=consecutivoID]').length); 
            var solicitudID=$('#solicitudCreditoID').val();
            $("#solicitudID").val(solicitudID); 
            
            $('#grabarInstruccion').click(function() {          
                $('#tipoTransaccion').val(1);
                guardaGridInstruccionDispersion();
            });
            $('#autorizarInstruccion').click(function() {          
                $('#tipoTransaccion').val(2);
                guardaGridInstruccionDispersion();
            });
            deshabilitaBoton('autorizarInstruccion', 'submit');

            if (perfilAnalista!="A" && perfilAnalista!="E"){ // validamso el perfil
                deshabilitaBoton('agregaEsquema', 'button');
                $('input[name=agregaE]').attr('disabled', 'disabled');
                $('input[name=elimina]').attr('disabled', 'disabled');
                $("input[name=beneficiarioID]").attr('disabled', 'disabled');
                $("input[name=beneficiarioID]").attr('readonly', 'readonly');
                $("input[name=cuentaID]").attr('disabled', 'disabled');
                $("input[name=cuentaID]").attr('readonly', 'readonly');
                $("input[name=lmontoAsignado]").attr('disabled', 'disabled');
                $("input[name=lmontoAsignado]").attr('readonly', 'readonly');
                $('#autorizarInstruccion').unbind('click');
                $('#grabarInstruccion').unbind('click');
                $('#agregaEsquema').unbind('click');
                deshabilitaBoton('autorizarInstruccion', 'submit');
                deshabilitaBoton('grabarInstruccion', 'submit');
            }else if(instrucccionesEstatus == "A"  ) {// validamos la situacion
                $('#agregaEsquema').remove();
                $('input[name=agregaE]').remove();
                $('input[name=elimina]').remove();
                $("input[name=beneficiarioID]").attr('disabled', 'disabled');
                $("input[name=beneficiarioID]").attr('readonly', 'readonly');
                $("input[name=cuentaID]").attr('disabled', 'disabled');
                $("input[name=cuentaID]").attr('readonly', 'readonly');
                $("input[name=lmontoAsignado]").attr('disabled', 'disabled');
                $("input[name=lmontoAsignado]").attr('readonly', 'readonly');
                $('#autorizarInstruccion').unbind('click');
                $('#grabarInstruccion').unbind('click');
                deshabilitaBoton('autorizarInstruccion', 'submit');
                deshabilitaBoton('grabarInstruccion', 'submit');
            }else if(solicitudEstatus == "A" ||  solicitudEstatus == "C"  ||  solicitudEstatus == "D"  ) { // validamos el estatus de la solicitud 
                deshabilitaBoton('agregaEsquema', 'button');
                $('input[name=agregaE]').attr('disabled', 'disabled');
                $('input[name=elimina]').attr('disabled', 'disabled');
                $("input[name=beneficiarioID]").attr('disabled', 'disabled');
                $("input[name=beneficiarioID]").attr('readonly', 'readonly');
                $("input[name=cuentaID]").attr('disabled', 'disabled');
                $("input[name=cuentaID]").attr('readonly', 'readonly');
                $("input[name=lmontoAsignado]").attr('disabled', 'disabled');
                $("input[name=lmontoAsignado]").attr('readonly', 'readonly');
                $('#autorizarInstruccion').unbind('click');
                $('#grabarInstruccion').unbind('click');
                $('#agregaEsquema').unbind('click');
                deshabilitaBoton('autorizarInstruccion', 'submit');
                deshabilitaBoton('grabarInstruccion', 'submit');
            }else if (solicitudEstatus == "L" && perfilAnalista !="A"){ // validamos la solicitud y el perfil de analista 
                deshabilitaBoton('agregaEsquema', 'button');
                $('input[name=agregaE]').attr('disabled', 'disabled');
                $('input[name=elimina]').attr('disabled', 'disabled');
                $("input[name=beneficiarioID]").attr('disabled', 'disabled');
                $("input[name=beneficiarioID]").attr('readonly', 'readonly');
                $("input[name=cuentaID]").attr('disabled', 'disabled');
                $("input[name=cuentaID]").attr('readonly', 'readonly');
                $("input[name=lmontoAsignado]").attr('disabled', 'disabled');
                $("input[name=lmontoAsignado]").attr('readonly', 'readonly');
                deshabilitaBoton('autorizarInstruccion', 'submit');
                deshabilitaBoton('grabarInstruccion', 'submit');
                $('#autorizarInstruccion').unbind('click');
                $('#grabarInstruccion').unbind('click');
                $('#agregaEsquema').unbind('click');
            }else if (solicitudEstatus == "L" && perfilAnalista=="A" ){ 
                $('#autorizarInstruccion').show();
                if(botonHabilitado == "S"){
                    habilitaBoton('autorizarInstruccion', 'submit');
                }else{
                    deshabilitaBoton('autorizarInstruccion', 'submit');
                }
            }else if (perfilAnalista!="A" ){
                deshabilitaBoton('autorizarInstruccion', 'submit'); 
                $('#autorizarInstruccion').unbind('click');
            }
        }else{              
            $('#divGridInstruccion').html("");
            $('#divGridInstruccion').hide(); 
        }

        $("input[name=beneficiarioID]").removeAttr('disabled');
        $("input[name=beneficiarioID]").removeAttr('readonly');
        $("select[name=dispersionID]").removeAttr('disabled');
        $("input[name=cuentaID]").removeAttr('disabled');
        $("input[name=cuentaID]").removeAttr('readonly');

    });

}