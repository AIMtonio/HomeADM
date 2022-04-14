
$(document).ready(function() {
	parametros = consultaParametrosSession();

	// Declaración de constantes
	var catTipoConsultaOrganoIntegra = {  
	  		'principal'		: 1	  		
		};	
		
	var catTipoTranOrganoIntegra = { 
		'alta'			: 1		
	};		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
  deshabilitaBoton('guardar', 'submit');
  agregaFormatoControles('formaGenerica');

  $.validator.setDefaults({
	    submitHandler: function(event) {    	  
	  	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','organoID',
	  			  				'exitoOrganoIntegra', 'falloOrganoIntegra');
	  	  
	    }
	 });	
	$('#guardar').click(function() {
		$('#tipoTransaccion').val(catTipoTranOrganoIntegra.alta);	
		guardarPuestosIntegra();
	});
	
	$('#organoID').change(function() {
		if(isNaN($('#organoID').val()) ){
			$('#organoID').val("");
			$('#organoID').focus();			
		 }else{ 
			 validaOrganoIntegra(this.id);
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			organoID: 'required'			
		},		
		messages: {
			organoID: 'Especifique el Organo de Decisión'
		}		
	});
	//------------ Validaciones de Controles -------------------------------------
	
		function validaOrganoIntegra(control) {
			var jqOrganoInt = eval("'#" +control + "'");
			var solOrg = $(jqOrganoInt).val();	
			
			if(solOrg != '' && !isNaN(solOrg)){								
				habilitaBoton('guardar', 'submit');
				consultaGridOrganosIntegra(solOrg);					
									
			}
		}
		
		

		
		consultaPuestosIntegra();
				
		function consultaPuestosIntegra() {			
			dwr.util.removeAllOptions('organoID'); 		
			dwr.util.addOptions('organoID', {0:'SELECCIONAR'});						     
			organoDecisionServicio.listaCombo(1, function(organos){
			dwr.util.addOptions('organoID', organos, 'organoID', 'descripcion');
			});
		}
		
		
		function guardarPuestosIntegra(){		
	 		var mandar = verificarvacios();

	 		if(mandar!=1){   		  		
				var numPuestos = $('input[name=consecutivoID]').length;
				
				$('#datosOrganoIntegra').val("");
				for(var i = 1; i <= numPuestos; i++){
					var valorAsignar=document.getElementById("asignado"+i+"").value;
					if(valorAsignar=='S'){
						if(i == 1){
							$('#datosOrganoIntegra').val($('#datosOrganoIntegra').val() +
							document.getElementById("clavePuestoID"+i+"").value + ']' +
							document.getElementById("asignado"+i+"").value);
						}else{
							$('#datosOrganoIntegra').val($('#datosOrganoIntegra').val() + '[' +
							document.getElementById("clavePuestoID"+i+"").value + ']' +
							document.getElementById("asignado"+i+"").value);
						}
					}
				}
	 		}											
			else{
				alert("Faltan Datos");
				event.preventDefault();
			}
		}	
		

		function verificarvacios(){	
			quitaFormatoControles('organoIntegra');
			var numPuestos = $('input[name=consecutivoID]').length;
			
			$('#datosOrganoIntegra').val("");
			for(var i = 1; i <= numPuestos; i++){
				
				var idcP = document.getElementById("clavePuestoID"+i+"").value;
	 			if (idcP ==""){
	 				document.getElementById("clavePuestoID"+i+"").focus();				
					$(idcP).addClass("error");	
	 				return 1; 
	 			}
	 			var idAsig = document.getElementById("asignado"+i+"").value;
	 			if (idAsig ==""){
	 				document.getElementById("asignado"+i+"").focus();				
					$(idAsig).addClass("error");	
	 				return 1; 
	 			}
	 				
			}
		}
	
		
});// FINN


function exitoOrganoIntegra(){
	consultaGridOrganosIntegra( $('#organoID').val());
}

function falloOrganoIntegra(){
	
}
// grid de puestos
function consultaGridOrganosIntegra(organoID){	
	var params = {};
	params['tipoLista'] = 1;
	params['organoID'] = organoID;
	params['clavePuestoID'] =0;
	
	$.post("organosIntegraGridVista.htm", params, function(data){
		if(data.length >0) {				
			$('#organoIntegra').html(data);
			$('#organoIntegra').show();
		}else{				
			$('#organoIntegra').html("");
			$('#organoIntegra').hide(); 
		}
	});
}

// Cambia el valor del campo Asignar al dar check
function realiza(control){		
	if($('#'+control).attr('checked')==true){
	document.getElementById(control).value = 'S';		
	}else{
		document.getElementById(control).value = 'N';
 }
		
}
//consulta filas del grid de puestos
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
		
	});
	return totales;
}


