$(document).ready(function() {



}); // cerrar

parametros = consultaParametrosSession();
var usuario = parametros.numeroUsuario;
deshabilitaBoton('autorizarInstruccion', 'submit');
//Declaración de constantes


agregaFormatoControles('formaGenerica1');

$.validator.setDefaults({
    submitHandler: function(event) {
        grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje', 'false', 'solicitudID',
            'exitoInstruccionAutorizacion', 'falloInstruccionAutorizacion');

    }
});

$('#formaGenerica1').validate({
    rules: {
        solicitudID: 'required'
    },

    messages: {
        solicitudID: 'Especifique solicitud de Crédito',
    }
});

function guardaGridInstruccionDispersion() {

    var mandar = 0;
    var dispersion = "";
    var beneficiarioID = "";
    var cuentaID = "";
    var montoAsignado = "";
    var permiteModificar = "";
    if (mandar != 1) {
        var numEsquema = $('input[name=consecutivoID]').length;
        quitaFormatoControles('divGridInstruccion');
        $('#datosGridInstruccion').val("");
        for (var i = 1; i <= numEsquema; i++) {
             dispersion = document.getElementById("dispersionID" + i + "").value
                beneficiarioID = document.getElementById("beneficiarioID" + i + "").value;
                 cuentaID = document.getElementById("cuentaID" + i + "").value;
                montoAsignado = document.getElementById("montoAsignado" + i + "").value;
                permiteModificar = document.getElementById("permiteModificar" + i + "").value;
            if (instrucccionesEstatus == "R"  ||  instrucccionesEstatus == ""  ){     
	            if (i == 1) {
	
	                if (dispersion == "") {
	                    mensajeSis('<p align="left">' + "Falta Tipo de Dispersi&oacute;n L&iacute;nea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
	                    return false;
	                }
	                if (beneficiarioID == "") {
	                    mensajeSis('<p align="left">' + "Falta Beneficiario L&iacute;nea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
	                    return false;
	                }
	                if (isNaN(cuentaID)) {
	                    mensajeSis('<p align="left">' + "La Cuenta debe ser solo en N&uacute;meros L&iacute;nea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
	                    return false;
	                }
                    if (cuentaID=="" && (dispersion=="T" || dispersion=="S")) {
                        mensajeSis('<p align="left">' + "La Cuenta no debe estar Vac&iacutea L&iacute;nea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        return false;

                    }
	                if (montoAsignado == "" || montoAsignado == "0.00" || montoAsignado == "0") {
	                    mensajeSis('<p align="left">' + "Falta  Monto Linea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
	                    return false;
	                }
	
	
	                $('#datosGridInstruccion').val($('#datosGridInstruccion').val() +
	                    document.getElementById("dispersionID" + i + "").value + ']' +
	                    document.getElementById("beneficiarioID" + i + "").value + ']' +
	                    document.getElementById("cuentaID" + i + "").value + ']' +
	                    $("#montoAsignado" + i + "").asNumber() + ']' +
	                    document.getElementById("permiteModificar" + i + "").value + ']' +
	                    document.getElementById("solicitudCreditoID").value);
	
	
	
	            } else {
	
	                if (dispersion == "") {
	                    mensajeSis('<p align="left">' + "Falta Tipo de Dispersi&oacute;n L&iacute;nea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
	                    return false;
	                }
	                if (beneficiarioID == "") {
	                    mensajeSis('<p align="left">' + "Falta Beneficiario L&iacute;nea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
	                    return false;
	                }
	                if (isNaN(cuentaID)) {
                        mensajeSis('<p align="left">' + "La Cuenta debe ser solo en N&uacute;meros L&iacute;nea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        return false;
                    }
	                 if (montoAsignado == "" || montoAsignado == "0.00" || montoAsignado == "0") {
	                    mensajeSis('<p align="left">' + "Falta  Monto L&iacute;nea " + i + '</p>');
                        $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
                        $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
	                    return false;
	                }
	
	                $('#datosGridInstruccion').val($('#datosGridInstruccion').val() + '[' +
	                    document.getElementById("dispersionID" + i + "").value + ']' +
	                    document.getElementById("beneficiarioID" + i + "").value + ']' +
	                    document.getElementById("cuentaID" + i + "").value + ']' +
	                    $("#montoAsignado" + i + "").asNumber() + ']' +
	                    document.getElementById("permiteModificar" + i + "").value + ']' +
	                    document.getElementById("solicitudCreditoID").value);
	               
	            }
            }
        }
    } else {
        mensajeSis("Faltan Datos");
        event.preventDefault();
    }
}





function agregaNuevoDetalle() {

    var numeroFila = document.getElementById("numeroEsquema").value;
    var nuevaFila = parseInt(numeroFila) + 1;
    if (nuevaFila == 0) {
        nuevaFila = 1;
    }

    var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';

    tds += '<td><input type="hidden" id="consecutivoID' + nuevaFila + '" name="consecutivoID" size="3" value="' + nuevaFila + '" autocomplete="off" />';


    tds += '<select  id="dispersionID' + nuevaFila + '" name="dispersionID" path="dispersionID" tabindex="' + nuevaFila + '6" type="text" onchange="ValidaTipoDispercion(this)">';
    tds += '<option value="">SELECCIONAR</option><option value="S">SPEI</option><option value="C">CHEQUE</option>';
    tds += '<option value="O">ORDEN DE PAGO</option><option value="E">EFECTIVO</option><option value="T">TRANSFERENCIA SANTANDER</option>';
    tds += '</select>';
    tds += '</td>';

    tds += '<td><input  id="beneficiarioID' + nuevaFila + '" name="beneficiarioID" value=""   maxlength="250" tabindex="' + nuevaFila + '7" COLS="50" ROWS="1" onblur="upperCaseBeneficiario(this)" /></td>';
    tds += '<td><input type="text" id="cuentaID' + nuevaFila + '" maxlength="20" name="cuentaID" value=""   tabindex="' + nuevaFila + '8" style="text-align:right;" /></td>';
    tds += '<td><input type="text" id="montoAsignado' + nuevaFila + '" name="lmontoAsignado"   tabindex="' + nuevaFila + '9" style="text-align:right;" esMoneda="true" path="lmontoAsignado" onblur="funcionIsNumeric(this.id)"  esMoneda="true"/>';
    tds += '<input type="hidden" id="permiteModificar' + nuevaFila + '" name="permiteModificar"  style="text-align:right;"  value="1"/></td>';
    tds += '<td align="center"> <input type="button" name="elimina" id="' + nuevaFila + '" class="btnElimina"   tabindex="' + nuevaFila + '9+1" onclick="eliminarInstruccionDispersion(this)"/>';
    tds += '<input type="button" name="agrega" id="agrega' + nuevaFila + '" class="btnAgrega" onclick="agregaNuevoDetalle()"  tabindex="' + nuevaFila + '9+1"/></td>';

    tds += '<td><input type="hidden" id="estatusSolicitud' + nuevaFila + '"  value="N" name="lestatusSolicitud" />';

    tds += '</tr>';


    document.getElementById("numeroEsquema").value = nuevaFila;
    $("#miTabla").append(tds);
    $('#dispersionID' + nuevaFila).focus();
    agregaFormatoControles('formaGenerica');
    $('#montoAsignado' + nuevaFila).formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });

    agregaTotales();

    return false;
}


function eliminarInstruccionDispersion(control) {
    $(control).closest('tr').remove();
    agregaTotales();
}



function consultaFilasInstruccionD() {
    var totales = 0;
    $('tr[name=renglon]').each(function() {
        totales++;

    });
    return totales;
}




function exitoInstruccionAutorizacion() {
    agregaFormatoControles('divGridInstruccion');
       //setTimeout("$('#solicitudCreditoID').blur();", 200);
        segrabo = true;
    //obtienestatus();

    //consultaGridInstruccionDispersionElegir();


}

function falloInstruccionAutorizacion() {
    agregaFormatoControles('divGridInstruccion');
}

//función para ingresar sólo números válido para diferentes tipos de Navegadores --- Omar Hdez
function Validador(e, elemento) {
    var key;
    if (window.event) { //IE, chromium
        key = e.keyCode;
    } else if (e.which) { //funciona para firefox opera netscape
        key = e.which;
    }

    if (key < 48 || key > 57) {
        if (key == 46 || key == 8) { // Detecta . (punto) y backspace (retroceso)
            return true;
        } else {
            mensajeSis("Sólo se Pueden Ingresar Números"); //Manda el mensajeSis de prevención
            return false;
        }
    }
    return true;
}






//FUNCION QUE CALCULA EL TOTAL ASIGNADO 
function agregaTotales() {
  

    var total = 0.00;
    botonHabilitado = "";
    $('input[name=lmontoAsignado]').each(function() {
        var jqmonto = eval("'#" + this.id + "'");
        var monto = $(jqmonto).asNumber();
        total += monto;
    });

    $('#totalAsignado').val(total);
    var totalGrabado=$('#totalGrabado').val();
    $('#totalAsignado').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });
     $('input[name=lmontoAsignado]').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2 });


    if (validaCubreMontoCredito(total,perfilAnalista) == true) {

         if(instrucccionesEstatus == "A" ) {
                $('#agregaEsquema').remove();
                 deshabilitaBoton('autorizarInstruccion', 'submit');
                  deshabilitaBoton('grabarInstruccion', 'submit');
                   $('#autorizarInstruccion').unbind('click');
                    $('#grabarInstruccion').unbind('click');
        }else{
        	if(total == totalGrabado){  
                if (solicitudEstatus == "L" && perfilAnalista =="A" ){
                  botonHabilitado = "S";
        		  habilitaBoton('autorizarInstruccion', 'submit');
                }
        	}
        }

    } else {


        deshabilitaBoton('autorizarInstruccion', 'submit');
    }

}



function validaCubreMontoCredito(totalAsignado,perfilAnalista) {
    var montosolicitud = $("#montoSolici").asNumber();
    var total = totalAsignado;
    var correcto = false;
    montosolicitud = parseFloat(montosolicitud);
    total = parseFloat(total).toFixed(2);
    
    if (montosolicitud == total) {
        $('#autorizarInstruccion').click(function() {
            $('#tipoTransaccion').val(2);
            guardaGridInstruccionDispersion();
        });
        correcto = true;
    }
    if(solicitudEstatus == "A" ||  solicitudEstatus == "C" ||  solicitudEstatus == "D" ) {
        deshabilitaBoton('grabarInstruccion', 'submit');
    }else{
    	if(perfilAnalista == 'A'){
    		habilitaBoton('grabarInstruccion', 'submit');
    	}else{
    		deshabilitaBoton('grabarInstruccion', 'submit');
    	}
    }
    if (montosolicitud < total) {
        $('#autorizarInstruccion').unbind('click');
        mensajeSis('<p align="left">' + "El Total Supera el Monto de la Solicitud" + '</p>');
        deshabilitaBoton('grabarInstruccion', 'submit');
    }


    return correcto;
}

//funcion para mayusculas del beneficiario

function upperCaseBeneficiario(event){
	event.value = event.value.toUpperCase(); 
}


//consulta cuantas a tranferir
function validaCuenta(control) {
    var numero = control.substring(14, 15);
    var clabe = $('#'+control).val();
    var clienteID = $('#clienteID').asNumber();
    var numConsulta = 1;

    setTimeout("$('#cajaLista').hide();", 200);

    if (clabe != '' && !isNaN(clabe)) {

        var bean = {
            'clienteID':$('#clienteID').val(),
            'clabe': 0,
            'cuentaTranID':clabe

        };
        cuentasTransferServicio.consulta(numConsulta, bean, {
            async: false,
            callback: function(cuenta) {
                if (cuenta != null) {
                
                    var beneficiario = cuenta.beneficiario;
                    var clabe = cuenta.clabe;
                    $('#beneficiarioID'+numero).val(beneficiario);
                    $('#cuentaID'+numero).val(clabe);

                } else {
                    $('#'+control).val("");
                    $('#cajaLista').hide();
                    mensajeSis("La Cuenta Clabe No Existe.");
                    $('#'+control).focus();
                    $('#'+control).val("");
                }
            }
        });
    }
}

function funcionIsNumeric(input){
	var value = $('#'+input).val();
    var RE = /^(\d{1,3}(\,\d{3})*|(\d+))(\.\d+)?$/;
    if($('#'+input).val() != '') {
    	if(!RE.test(value)) {
    		agregaTotales();
    		mensajeSis('Valide que el Valor Ingresado sea Correcto y Mayor a Cero');
    		$('#'+input).val('');
    		agregaTotales();
    		$('#'+input).focus();
    	} else {
    		agregaTotales();
    	}
    }
}

function ValidaTipoDispercion(input) {

    var numero = input.id.substring(12, 13); 
    var tipo = input.value;
    if (tipo == "S") {
        $("#cuentaID" + numero).val('');
        $("#beneficiarioID" + numero).val('');
        $("#beneficiarioID" + numero).addClass("validaBeneficiario beneficiarioclass");
        $("#cuentaID" + numero).attr('disabled', 'disabled');

        $('.beneficiarioclass').unbind('keyup');
        $('.beneficiarioclass').unbind('blur');

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
                	validaCuenta(this.id);
            }
        });

    } else {
        $("#beneficiarioID" + numero).removeClass("validaBeneficiario beneficiarioclass");
        $("#cuentaID" + numero).removeAttr('disabled');
        $("#beneficiarioID" + numero).unbind('keyup');
        $("#beneficiarioID" + numero).unbind('blur');

    }
}
