$(document).ready(function(){
	
	var Ext_Adjuntar_Archivo={
			'tipoKey':1,
			'tipoCer':2
	};
	
	agregaFormatoControles('formaGenerica');
	
	$.validator.setDefaults({
	    submitHandler: function(event) {
	    	grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma', 'mensaje','true','contrasena','exito','fallo');
	      }
	 });
	
	$('#formaGenerica').validate({			
		rules: {				
			contrasena: {
				required: true						
			},				
			archivoK:{
				required: true	
			},
			archivoC:{
				required:true
			}
		},		
		messages: {
			contrasena: {
				required: 'Contraseña requerida'				
			},
			archivoK:{
				required:'Dirección .key requerido'				
			},
			archivoC:{
				required:'Dirección .Cer requerido'				
			}
		}		
	});
	
	$('#adjuntarK').click(function(){
		$('#tipoExt').val(Ext_Adjuntar_Archivo.tipoKey);
		subirArchivos($('#tipoExt').val());
	});
	$('#adjuntarC').click(function(){
		$('#tipoExt').val(Ext_Adjuntar_Archivo.tipoCer);
		subirArchivos($('#tipoExt').val());
	});
	
	function subirArchivos(ext) {		
 		var url ="edoCtaCertificadoGuardarArchivo.htm?tipoExtension="+ext;
 		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
 		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
 		ventanaArchivosCliente = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+ 				
 										"left="+leftPosition+
 										",top="+topPosition+
 										",screenX="+leftPosition+
 										",screenY="+topPosition); 
 	}	

});	
function exito(){	
	agregaFormatoControles('formaGenerica');
	borrarDatos();
}
function fallo(){		
	agregaFormatoControles('formaGenerica');
	$('#contrasena').val('');
}
function borrarDatos(){
	$('#contrasena').val('');
	$('#archivoK').val('');
	$('#rutaCompletaKey').val('');
	$('#archivoC').val('');
	$('#rutaCompletaCer').val('');
}