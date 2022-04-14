var catTipoTransaccion = {
	'elimina' : '3'
};

var esTab = false;

$(document).ready(function() {
	consultaImagenes();	
	
	var parametroBean = consultaParametrosSession();
	
	$("#nuevaImagen").focus();
	
	$('input').focus(function() {
		esTab = false;
	});

	$('input').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$('input').blur(function() {
		if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout(function() {
				$('#formaGenerica :input:enabled:visible:first').focus();
			}, 0);
		}
	});
	$.validator.setDefaults({
		submitHandler: function(event) { 	
		grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaAhoID');
	 	}
	});		   			
	    
	$('#nuevaImagen').click(function() {
		subirArchivos();
	});

	$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#descripcion').focus();
	});
	
	$('#descripcion').change(function() {	
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);	
	
	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			
			descripcion: {
				required: true
			},
			file: { required: true,filesize: 3145728  }		
			
		},
		messages: {
			descripcion: {
				required: 'Especificar descripcion'
			}	,
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB' 
			}	 
		}		
	});
	
//------------ Validaciones de Controles -------------------------------------
		
});

function eliminaImagen(idControl) { 
	$('#tipoTransaccion').val('3');
	$('#archivoCuentaID').val(idControl);
	confirmarEliminar(idControl) ;
}

function confirmarEliminar(idControl) {
	/*mensajeSisRetro({
	    txtCabecera:  'Advertencia:',
	    mensajeAlert : '¿Deseas eliminar el archivo?',
		muestraBtnAceptar: true,
		muestraBtnCancela: true,
		txtAceptar : 'Aceptar',
		txtCancelar : 'Cancelar',

		funcionAceptar : function(){
			//bajaImagen(idControl);
			$('#tipoTransaccion').val(catTipoTransaccion.elimina);
			grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true','nuevaImagen','funcionExito', 'funcionError');
			//grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','nuevaImagen');
			return true;
		},
		funcionCancelar : function(){
         	return false;
		},
		funcionCerrar   : function(){
		 	return false;
	    	mensajeSis("El Usuario cerro el cuadro de dialogo sin tomar ninguna opcion");
		}
	});
	consultaImagenes();*/
	
	$('#tipoTransaccion').val(catTipoTransaccion.elimina);
	$('#imagenAntiphishingID').val(idControl);
	mensajeSisRetro({
		mensajeAlert : '¿Deseas eliminar el archivo?.',
		muestraBtnAceptar: true,
		muestraBtnCancela: true,
		txtAceptar : 'Aceptar',
		txtCancelar : 'Cancelar',
		funcionAceptar : function(){
			//grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'false', 'nuevaImagen','funcionExito','funcionError');
			bajaImagen(idControl);
		},
		funcionCancelar : function(){

		}
	});
		
}
function bajaImagen(idControl){
	//Estableciendo el bloqueo de pantalla
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
	
	$('#contenedorForma').block({
		message: $('#mensaje'),
		css: {border:		'none',
			background:	'none'}
	});
	setTimeout(function(){},3000);

	imagenAntiphishingServicio.bajaImagen(idControl,1, function(mensaje){
		if(mensaje != null){
			mensajeSis(mensaje.descripcion);
			$("#contenedorForma").unblock();
			consultaImagenes();
		}else{
			mensajeSis("Ocurrio un Error al Borrar La Imagen");	
		}
		
	});
	
}


var parametrosBean = consultaParametrosSession();
var rutaArchivos = parametrosBean.rutaArchivos;
var ventanaArchivosCliente ="";

function subirArchivos() {
	var url ="imagenUpload.htm";
	var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
	var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

	ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
									"left="+leftPosition+
									",top="+topPosition+
									",screenX="+leftPosition+
									",screenY="+topPosition);	
	
}


function verImagen(id) { 
	console.log("ver imagen"+id);
	var imagenAntiphishingID = id;
	var parametros = "?imagenAntiphishingID="+imagenAntiphishingID;
		
		imagenAntiphishingServicio.consulta(1,imagenAntiphishingID ,function(imagen) {
			$('#imgCliente').attr("src","data:image/jpg;base64,"+imagen.imagenBinaria).attr("width","500"); 		
		});
	
		 $.blockUI({message: $('#imagenCte'),
			   css: { 
         top:  ($(window).height() - 400) /2 + 'px', 
     } });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);		
}

function consultaImagenes(){
			var params = {};		
			params['tipoLista'] = 1;
			params['identificador'] = 1;
			$.post("listaImagenesAnt.htm", params, function(data){		
						$('#listaImagenes').html(data);
						$('#listaImagenes').show();
						$("#nuevaImagen").focus();
						asignarTabs();
	});
	
}
function funcionExito(){
	consultaImagenes();
}
function funcionError(){}


var tabGeneral = 10;

function asignarTabs(){
	tabGeneral = 10;
	asignarTabIndexImagenes();
}

function asignarTabIndexImagenes(){
	var numeroTab = tabGeneral;
	
	$('#tablaLista tr').each(function(index) {
		if(index > 0){
			numeroTab++;
			$('#' + $(this).find("input[name^='ver']").attr('id')).attr('tabindex' , numeroTab);
			numeroTab++;
			$('#' + $(this).find("input[name^='elimina']").attr('id')).attr('tabindex' , numeroTab);
		}
	});
	
	tabGeneral = numeroTab;
}