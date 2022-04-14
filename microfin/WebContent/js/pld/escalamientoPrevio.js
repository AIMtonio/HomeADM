$(document).ready(function() {
	
	consultaEscalamientoPrevio();
	
	var catTipoTransaccion = {
	  		'agregar'	: 1,
	  		'modificar'	: 2,
	  		'baja'		: 3
		};
	var catTipoConsultaEscalamiento = {
  		'principal'	: 1
  		
	};	

	var catTipoConsultaRol = {
	  		'principal'	: 1,
		};
	
//------------ Metodos y Manejo de Eventos -----------------------------------------
	

	 deshabilitaBoton('historico', 'submit');
	$('#folioID').focus();
	 agregaFormatoControles('formaGenerica');
	 var parametroBean = consultaParametrosSession(); 
		$(':text').focus(function() {	
		 	esTab = false;
		});
		
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});

		$.validator.setDefaults({
			submitHandler : function(event) {
				resultadoTransaccion =
					  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioID','funcionExito',''); 
							
			}
		});
		
	$('#grabar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccion.agregar);		
	 });	
	
	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modificar);		
  	});
	
	$('#baja').click(function() {
	$('#tipoTransaccion').val(catTipoTransaccion.baja);		
	});

	$('#rolTitular').bind('keyup',function(e){
		lista('rolTitular', '1', '2', 'nombreRol', $('#rolTitular').val(), 'listaRoles.htm');
	});
	
	$('#rolTitular').blur(function() { 
  		validaRolTitular(this.id); 
	});		
	
	$('#rolSuplente').bind('keyup',function(e){
		lista('rolSuplente', '1', '2', 'nombreRol', $('#rolSuplente').val(), 'listaRoles.htm');
	});
	
	$('#rolSuplente').blur(function() { 
  		validaRolSuplente(this.id); 
	});
	
	
	$('#folioID').blur(function() { 
		consultaFoliovigentePrevio(); 
	});
	
	  //------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({					
		rules: {				
			nivelRiesgoID: {
				required: true
			},
	
			rolTitular: {
				required: true,
			},
			
			rolSuplente: {
				required: true
			}
			
		},		
		
		messages: {		
		
			nivelRiesgoID: {
				required: 'Especifique Nivel de Riesgo.',
			},
			
			rolTitular: {
				required: 'Especifique Puesto Titular',
			},
			
			rolSuplente: {
				required: 'Especifique Puesto Suplente'
			}

		}		
	});
	
	
	/* ***********************************FUNCIONES******************************  */

	function consultaCampos(){
				
				var bean = {
						rolTitular: $('#rolTitular').val()
				};
				
				escalaSolServicio.consultaRol(1,bean, function(escalamiento){
					if (escalamiento != null ){
						$('#descripcion').val(escalamiento.rolTitularDescripcion);
					}					
				});
			}



	function consultaSuplente(){
		
		var bean = {
				rolTitular: $('#rolSuplente').val()
		};
		
		escalaSolServicio.consultaRol(1,bean, function(escalamiento){
			if (escalamiento != null ){
				$('#descripcionSuplente').val(escalamiento.rolTitularDescripcion);
			}
		});		
	}

	
	function consultaEscalamientoPrevio() {

		var escalamientoBeanCon = {
			'nivelRiesgoID'	: 	$('#nivelRiesgoID').val()
		};
		escalamientoPrevioServicioScript.consulta(1,escalamientoBeanCon,function(escalamientoPrevio) {
			if(escalamientoPrevio!=null){
				//dwr.util.setValues(escalamientoPrevio);
				
       	$('#rolTitular').val(escalamientoPrevio.rolTitular) ;	
       	$('#rolSuplente').val(escalamientoPrevio.rolSuplente) ;
       	$('#nivelRiesgoID').val(escalamientoPrevio.nivelRiesgoID).selected = true;
    	$('#folioID').val(escalamientoPrevio.folioID) ;	
       	$('#fechaVigencia').val(escalamientoPrevio.fechaVigencia) ;	
       	$('#estatus').val(escalamientoPrevio.estatus) ;	

        consultaSuplente();	
	    consultaCampos();
	    
			    if(escalamientoPrevio.estatus == 'V'){
					deshabilitaBoton('grabar','submit');
					habilitaBoton('modifica','submit');
					habilitaBoton('baja','submit');
				} 
				if(escalamientoPrevio.estatus == 'B'){
					deshabilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');
				}
		
		}});
	}
	
	
	function consultaFoliovigentePrevio() {

		var escalamientoBeanCon = {
			'folioID'	: 	$('#folioID').val()
		};
		
		if($('#folioID').val() == 0){
			escalamientoPrevioServicioScript.consulta(1, escalamientoBeanCon, function(datos){
				if(datos != null){ 
					var folioVigente = datos.folioID;
					if(datos.estatus != 'V'){ 
					inicializaForma('formaGenerica','folioID');
					$('#fechaVigencia').val(parametroBean.fechaAplicacion);
					$('#nivelRiesgoID').val('');
					$('#estatus').val('V');
					habilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');
				}else{
					alert("El Folio "+folioVigente+" se encuentra Vigente");
					$('#folioID').val(folioVigente);
					$('#folioID').focus();
					deshabilitaBoton('grabar','submit');
					habilitaBoton('modifica','submit');
					habilitaBoton('baja','submit');
					}
				}else{
					$('#fechaVigencia').val(parametroBean.fechaAplicacion);
					$('#nivelRiesgoID').val('');
					$('#estatus').val('V');
					habilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');
				}		
			});
		
		}else{
		
		escalamientoPrevioServicioScript.consulta(2,escalamientoBeanCon,function(escalamientoPrevio) {
			if(escalamientoPrevio!=null){		
		       	$('#rolTitular').val(escalamientoPrevio.rolTitular) ;	
		       	$('#rolSuplente').val(escalamientoPrevio.rolSuplente) ;
		       	$('#nivelRiesgoID').val(escalamientoPrevio.nivelRiesgoID).selected = true;
		    	$('#folioID').val(escalamientoPrevio.folioID) ;	
		       	$('#fechaVigencia').val(escalamientoPrevio.fechaVigencia) ;	
		       	$('#estatus').val(escalamientoPrevio.estatus) ;	

        consultaSuplente();	
	    consultaCampos();
	    
			    if(escalamientoPrevio.estatus == 'V'){
					deshabilitaBoton('grabar','submit');
					habilitaBoton('modifica','submit');
					habilitaBoton('baja','submit');
				} 
				if(escalamientoPrevio.estatus == 'B'){
					deshabilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');
				}
		
				}else{
					alert("No existe el Folio Indicado");
					$('#peps').attr("checked","1") ;
					$('#actuaCuenTer').attr("checked","1") ;
					$('#dudasAutDoc').attr("checked","1") ;
					
					inicializaForma('formaGenerica','folioID');
					$('#folioID').val('');
					$('#folioID').focus();
					$('#fechaVigencia').val('');
					$('#nivelRiesgoID').val('');
					$('#estatus').val('');
					deshabilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');	
				}
			
			});
		}
	 }
	
	// funcion para consultar el rol del titular
	function validaRolTitular(control) {
			var numRol = $('#rolTitular').val();
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol)){

					var rolBeanCon = { 
	  				'rolID':numRol
	  				
					};
					
					rolesServicio.consultaRoles(catTipoConsultaRol.principal,rolBeanCon,function(rol) {
							if(rol!=null){
								$('#descripcion').val(rol.descripcion);
								dwr.util.setValues(rol);	
																			
							}else{									
								alert("No Existe el rol");
								$('#rolTitular').focus();
								$('#rolTitular').val('');	
																				
								}
					});														
				}
		}
		
		
		// funcion para consultar el rol del suplente
		function validaRolSuplente(control) {
			var numRol = $('#rolSuplente').val();
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol)){

					var rolBeanCon = { 
	  				'rolID':numRol
	  				
					};
					
					rolesServicio.consultaRoles(catTipoConsultaRol.principal,rolBeanCon,function(rol) {
							if(rol!=null){
								$('#descripcionSuplente').val(rol.descripcion);
										
							}else{									
								alert("No Existe el rol");
								$('#rolSuplente').focus();
								$('#rolSuplente').val('');	
																				
								}
					});														
				}
		}

});


function funcionExito(){

}


function funcionError(){
	
}

