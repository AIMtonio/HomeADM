var tipoTransaccion = {
	'alta': 1,
    'procesaAnterior': 3
};
$(document).ready(function() {
    esTab = true;
    $('#tipoTransaccion').val(0);
    agregaFormatoControles('formaGenerica');
    deshabilitaBoton('generar', 'button');
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
        if ($('#folioID').val() == 0 && $('#folioID').val() != '') {
            limpiarDatos();
            deshabilitaBoton('generar', 'button');
            $('#folioID').val("0");
        }
        
    })

    $('#institNominaID').blur(function(event) {
        if($("#institNominaID").val()!="" && $("#institNominaID").val()!=0){
            consultaNomInstit();
        }
    })
    $('#institNominaID').bind('keyup', function(e) {
        lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
    });

    $('#convenioNominaID').blur(function(event) {
        if($("#convenioNominaID").val()!="" && $("#convenioNominaID").val()!=0 && esTab){
            consultaConvenioNomina();
        }
    });
    $('#convenioNominaID').bind('keyup', function(e) {
        var camposLista = new Array();
        var parametrosLista = new Array();
        camposLista[0] = 'institNominaID';
        camposLista[1] = 'descripcion';
        parametrosLista[0] = $('#institNominaID').val();
        parametrosLista[1] = $('#convenioNominaID').val();
        if($('#institNominaID').asNumber()==0){
            lista('convenioNominaID', '2', 7, camposLista, parametrosLista, 'listaConveniosNomina.htm');
        }else{
            lista('convenioNominaID', '2', 1, camposLista, parametrosLista, 'listaConveniosNomina.htm');
        }
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

    $('#generar').click(function() {
        
        if ($('#folioID').val() == '') {
            $('#folioID').focus();
        } else if ($("#descripcion").val() == '') {
            $('#descripcion').focus();
        } else if ($('#folioID').val() == 0){
            VerificarSiHayFolioAnterior();
        } 
        
    })
});

function VerificarSiHayFolioAnterior(){
    var bean = {
		'institNominaID' : $('#institNominaID').val(),
        'convenioNominaID' : $('#convenioNominaID').val()
	};
    
	archivoInstalServicio.consulta(2, bean, function(archivoInstal){
		if (archivoInstal != null){
            $('#folioIDAnterior').val(parseInt(archivoInstal.folioID));
			var parametros = {
                mensajeAlert : 'No se ha cargado ningún archivo de instalación, ¿Esta seguro de continuar?',
                muestraBtnAceptar: true,
                muestraBtnCancela: true,
                muestraBtnCerrar: true,
                txtAceptar : 'Aceptar',
                txtCancelar : 'Cancelar',
                txtCabecera:  'Mensaje:',
                funcionAceptar : function() {continuarCarga();},
                funcionCancelar : function (){mensajeSis("Proceso cancelado.");},
                funcionCerrar   : function (){mensajeSis("Proceso cancelado.");}
        
            };
            
            mensajeSisRetro(parametros);
		} else {
            continuarProcesoGeneracion();
		}
	});
}

function cancelarCarga(){
    mensajeSis("Proceso cancelado.");
}

function continuarCarga(){
    $('#tipoTransaccion').val(tipoTransaccion.procesaAnterior);
    grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma',
            'mensaje', 'true', 'folioIDAntiguo','continuarProcesoGeneracion','funcionFracaso'); 
    deshabilitaBoton('generar', 'button'); 
}

function continuarProcesoGeneracion(){
    $('#tipoTransaccion').val(tipoTransaccion.alta);
    grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma',
            'mensaje', 'true', 'folioID','funcionExito','funcionFracaso'); 
    deshabilitaBoton('generar', 'button'); 
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

/**
 * Método que limpia los campos de la vista.
 */
function limpiarDatos(){
    $('#descripcion').val('');
    $('#institNominaID').val('');
    $('#nombreInstit').val('');
    $('#convenioNominaID').val('');
    $('#nombreConvenio').val('');
}

/**
 * Función de éxito al realizarse la acción de Alta.
 */
function funcionExito(){
    generarlExcel();
    limpiarDatos();
}

// Método que realiza el llamado al controlador para la generación del reporte.
function generarlExcel(){
    $('#ligaGenerar').attr('href',
    );
    var url = 'reporteArchivoInstalacion.htm'+
            `?claveUsuario=${parametroBean.claveUsuario}`+
            `&usuario=${parametroBean.nombreUsuario}`+
            `&fechaSistema=${parametroBean.fechaAplicacion}`+
            `&nombreInstitucion=${parametroBean.nombreInstitucion}` +
            `&tipoReporte=${1}`+
            `&folioID=${$("#folioID").val()}`+
            `&descipcion=${$("#Descrip").val()}`+
            `&institNominaID=${$("#institNominaID").val()}`+
            `&nombreInstitucion=${$("#nombreInstit").val()}`+
            `&convenioNominaID=${$("#convenioNominaID").val()}`+
            `&nombreConvenio=${$("#nombreConvenio").val()}`;

    window.open(url, '_blank');
}

function exitoActualizacion(){
    
}

function funcionFracaso(){

}