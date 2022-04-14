var catTipoRepVencimientos = { 
            'PDF'       : 1
    };

$(document).ready(function() {

    agregaFormatoControles('formaGenerica');
    $("#clienteID").focus();

    var catTipoConsultaCliente = {
        'principal': 1
    };
    
	var catTipoConsultaRiesgo = {  
	  		'operacion':1,
	  		'riesgoActual':2
			};

    $('#imprimir').hide();

    $('#clienteID').bind('keyup', function(e) {
        lista('clienteID', '2', '10', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
    });

    $('#clienteID').blur(function() {
        resetForma();
        $('#tipoConsulta').val("");

     

        consultaCliente(this.id);
               


        
    });

    $('#tipoConsulta').change(function() {
    	resetForma();
        $("#resultadosGrid").html("");

        if($('#clienteID').val()=="" || isNaN($('#clienteID').val())){
            $('#clienteID').val('');
            $('#nombreCompleto').val('');
            $('#cajaLista').hide();
            mensajeSis("Capture el No. de Cliente");
            $('#clienteID').focus();
            return false;
        }


        switch ($('#tipoConsulta').val()) {
            case "O":
                $('#filtros').show();
                habilitaControl('tipoOperacion');
                deshabilitaControl('tipoInstrumento');
                $("#tipoCon").val(catTipoConsultaRiesgo.operacion);
                $('#imprimir').hide();
                break;
            case "R":
                $('#filtros').hide();
                $("#tipoCon").val(catTipoConsultaRiesgo.riesgoActual);                
                if ($('#clienteID').val() != ""){
                consultaEvaluacion();
                }else{
                mensajeSis("Capture el No. de Cliente");
                 $("#clienteID").focus();
                }
                break;
            default:
                $('#imprimir').hide();

 
        }
    });

    $('#tipoOperacion').change(function() {
        if ($('#tipoOperacion').val() != "") {
            consultaInstrumentos();
            habilitaControl('tipoInstrumento');
        }

    });

    $('#tipoInstrumento').change(function() {
        if ($('#tipoInstrumento').val() != "") {
            consultaEvaluacion();
        } else {
        	$("#resultadosGrid").html("");
        	mensajeSis("No se Encontraron Operaciones de Escalamiento Para este Cliente");
        }

    });

    $('#imprimir').click(function() {
        imprimir();
    });



    limpiaPuntajesCliente();
    consultaProcesoEscalamiento();
    // ////////////////funcion consultar cliente////////////////
    function consultaCliente(idControl) {
        var jqCliente = eval("'#" + idControl + "'");
        var numCliente = $(jqCliente).val();
        setTimeout("$('#cajaLista').hide();", 200);


        if (numCliente != '' && Number(numCliente) > 0) {
            clienteServicio.consulta(catTipoConsultaCliente.principal, numCliente, function(cliente) {
                if (cliente != null) {
                    if (cliente.estatus == 'I') {
                    	mensajeSis('El Cliente se Encuentra Inactivo');
                        $('#clienteID').focus();
                        $('#clienteID').val('');
                        $('#nombreCompleto').val('');
                        resetForma();
                    } else {
                        $('#nombreCompleto').val(cliente.nombreCompleto);
                        deshabilitaControl('nombreCompleto');
                    }

                } else {
                	mensajeSis('No Existe el Cliente');
                    $('#clienteID').focus();
                    $('#clienteID').val('');
                    $('#nombreCompleto').val('');
                    resetForma();
                }
            });
        }
    }

    //------------ Validaciones de Controles -------------------------------------

});


function consultaEvaluacion() {
    bloquearPantalla();
    var params = {};
    params['tipoConsulta'] = $("#tipoCon").val();
    params['clienteID'] = $("#clienteID").val();
    params['tipoProceso'] = $("#tipoOperacion").val();
    params['operProcesoID'] = $("#tipoInstrumento").val();

    $.post("nivelRiesgoClienteGridPLD.htm", params, function(data) {
        $('#resultadosGrid').html(data);
        $('#resultadosGrid').show();
        agregaFormatoControles('formaGenerica');
        desbloquearPantalla();
        if($('#tipoConsulta').val() == 'R'){
            $('#imprimir').show();
        }
    });

}

// funcion para llenar el combo de procesos de escalamiento
function consultaProcesoEscalamiento() {
    dwr.util.removeAllOptions('tipoOperacion');
    dwr.util.addOptions('tipoOperacion', {
        '': 'SELECCIONAR'
    });
    procesoEscalamientoInternoServicio.listaCombo(1, function(procesoEscala) {
        dwr.util.addOptions('tipoOperacion', procesoEscala, 'procesoEscalamientoID', 'descripcion');
    });
}

function consultaInstrumentos() {
    bloquearPantalla();
    var clienteID = $("#clienteID").val();
    var tipoProceso = $("#tipoOperacion").val();
    var beanNivelRiesgo = {
        'clienteID': clienteID,
        'tipoProceso': tipoProceso
    };
    dwr.util.removeAllOptions('tipoInstrumento');
    dwr.util.addOptions('tipoInstrumento', {
        '': 'SELECCIONAR'
    });
    nivelRiesgoClientePLD.listaInstrumentos(beanNivelRiesgo, function(lista) {
        dwr.util.addOptions('tipoInstrumento', lista, 'operProcesoID', 'operProcesoID');
        desbloquearPantalla();

        if (lista.length <= 0) {
        	$("#resultadosGrid").html("");
        	mensajeSis("No se Encontraron Operaciones de Escalamiento Para este Cliente");
        }
    });
}


function resetForma() {
    $("#resultadosGrid").html("");
    $("#filtros").hide();
    deshabilitaControl('tipoOperacion');
    deshabilitaControl('tipoInstrumento');
    $("#tipoOperacion").val("");
    $("#tipoInstrumento").val("");
    $('#resultadosGrid').html("");
    $('#imprimir').hide();

}


function imprimir() {
         
            var tr= catTipoRepVencimientos.PDF; 
                
            var clienteID =$('#clienteID').val();
            var fechaEmision = parametroBean.fechaSucursal;
            var usuario =   parametroBean.claveUsuario;
        
            /// VALORES TEXTO
            var nombreCliente = $('#nombreCompleto').val();
            
            var nombreInstitucion =  parametroBean.nombreInstitucion; 
            var nombreSucursal=parametroBean.nombreSucursal;

            if(nombreCliente=='0'){
                nombreCliente='';
                
            }else{
                nombreCliente = $("#clienteID option:selected").html();
            }
        
            url = 'reporteNivelRiesgosPLD.htm?'+'clienteID='+clienteID  
                    +'&fechaEmision='+fechaEmision+
                    '&nomUsuario='+usuario+
                    '&nomInstitucion='+nombreInstitucion+'&nomSucursal='+ nombreSucursal;

            window.open(url);

            $('#nombreCompleto').val('');
            $('#clienteID').val('');
            $('#clienteID').focus();

            
            
            
}

function limpiaPuntajesCliente() {
    $('.puntajeObtenido').val("0");
}