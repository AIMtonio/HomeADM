var tipoTransaccion = {
	'alta': 1,
	'procesarArchivo' : 2
};
$(document).ready(function() {
    esTab = true;

    agregaFormatoControles('formaGenerica');
    deshabilitaBoton('grabar', 'button');
    deshabilitaBoton('adjuntar', 'button');
    $('#folioID').focus();

    $.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma',
					'mensaje', 'true', 'folioID','exitoActualizacion','falloActualizacion');
    	}
    });

    $(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$(':text').focus(function() {
		esTab = false;
    });
    
    // Definicion de Constantes y Enums
    var parametroBean = consultaParametrosSession();

    $('#folioID').blur(function (event) {
        if ($('#folioID').val() != 0 && $('#folioID').val() != '') {
        	consultarFolioArchivo();
        }
        
    });
    
    $('#folioID').bind('keyup', function(e) {
        lista('folioID', '2', '1', 'descripcion', $('#folioID').val(), 'archivoInstalLista.htm');
    });

    // ------------ Validaciones de la Forma ----------------
    $('#formaGenerica').validate({
        rules: {
            folioID:    {
                required: true,
                number: true
            },
            descripcion:    {
                required: true
            },
            institNominaID: {
                required: true,
                number: true
            },
            convenioNominaID: {
                required: true,
                number: true
            }
        },
        messages: {
            folioID:    {
                required: "El folio es Requerido.",
                number: "Solo Números."
            },
            descripcion:    {
                required: "Se requiere Descipción"
            },
            institNominaID: {
                required: "La institución de nómina es Requerida.",
                number: "Solo Números."
            },
            convenioNominaID: {
                required: "El convenio de nómina es Requerido.",
                number: "Solo Números."
            }
        }
    });
    
    $('#adjuntar').click(function(){
    	if ($('#folioID').val() == '' || $('#folioID').val() == 0) {
            $('#folioID').focus();
            mensajeSis("Seleccionar un folio de instalación");
        } else {
        	subirArchivos();
        	habilitaBoton('grabar', 'button');
        }
    });

    $('#grabar').click(function() {
        $('#tipoTransaccion').val(tipoTransaccion.procesarArchivo);
        if ($('#folioID').val() == '' || $('#folioID').val() == 0) {
            $('#folioID').focus();
        } else {
            $('#gridArchivoInstalacion').html("");
            $('#gridArchivoInstalacion').hide();
        	grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma',
					'mensaje', 'true', 'folioID','funcionExito','funcionFracaso'); 
            deshabilitaBoton('grabar', 'button');       	
        } 
        
    })
});

/**
 * Función para Subir Archivos para leer archivo de instalación
 */
function subirArchivos() {
    var url = "archivoInstalCarga.htm" +
    	 "?folioID=" + $('#folioID').val();
    var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
    var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;

    ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=320,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0" +
        "left=" + leftPosition +
        ",top=" + topPosition +
        ",screenX=" + leftPosition +
        ",screenY=" + topPosition);
}

/**
 * Función que permite la consuta de información al servidor de un determinado folio de instalación.
 */
function consultarFolioArchivo(){
	var bean = {
		'folioID' : $('#folioID').val()
	};
	
	archivoInstalServicio.consulta(1, bean, function(archivoInstal){
		if (archivoInstal != null){
			$("#descripcion").val(archivoInstal.descripcion);
			$("#institNominaID").val(archivoInstal.institNominaID);
			$("#convenioNominaID").val(archivoInstal.convenioNominaID);
			consultaNomInstit();
			consultaConvenioNomina();
			habilitaBoton('adjuntar', 'button');
		} else {
			mensajeSis("El folio no existe");
		}
	});
}


/**
 * Método que consulta la información de la institución de nómina a partir de su identificador.
 */
function consultaNomInstit() {
    var institNominaBean = {
            'institNominaID' : $("#institNominaID").val()
    };
    institucionNomServicio.consulta(1, institNominaBean, function(institucionNomina) {
        if(institucionNomina != null){
            $('#nombreInstit').val(institucionNomina.nombreInstit);
        }
    });
}

/**
 * Método que consulta la información de la convención de nómina a partir de su identificador.
 */
function consultaConvenioNomina() {
	var convenioBean = {
		'convenioNominaID': $("#convenioNominaID").val()
	};
	conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
		if(resultado != null) {
			if($('#institNominaID').val()==0 ||
					(resultado.institNominaID == $('#institNominaID').val())){
                $("#nombreConvenio").val(resultado.descripcion);
                habilitaBoton('generar', 'submit');
			}else{
                mensajeSis("El convenio "+$("#convenioNominaID").val()+" no corresponde con la Empresa de Nómina.");
                $('#convenioNominaID').val();
                $('#nombreConvenio').val();
			}
			
		}else{
			mensajeSis("El convenio no existe");
		}
	});
}

function consultaGrid(){
    var params = {};
	params['tipoLista'] = 1;
	params['folioID'] = $("#folioID").asNumber();
	$.post("archivoInstalGrid.htm", params, function(dat) {
		if (dat.length > 0) {
			$('#grid').show();
			$('#gridArchivoInstalacion').html(dat);
			agregaFormatoControles('formaGenerica');
			$('#gridArchivoInstalacion').show();
		} else {
			$('#gridArchivoInstalacion').html("");
			$('#gridArchivoInstalacion').show();
			$('#grid').hide();
		}
	});
}

/**
 * Método que limpia los campos de la vista.
 */
function limpiarDatos(){
    $('#descripcion').val('');
    $('#institNominaID').val('');
    $('#nombreInstit').val('');
    $('#convenioNominaID').val('');
    $('#nombreConvenio').val('');
    $('#gridArchivoInstalacion').html("");
    $('#gridArchivoInstalacion').hide();
}

/**
 * Función de éxito al realizarse la acción de Alta.
 */
function funcionExito(){
    consultaGrid();
}


function funcionFracaso(){

}