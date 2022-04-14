$(document).ready(function() {
		esTab = true;
		otra = false;
		otroTab = false;
		var listado = false;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCapturaOpInusuales = {  
  		'alta':2
		};
	


	 $('#desplegado1').focus();
	
		//------------ Msetodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('guardar', 'submit');
	 agregaFormatoControles('formaGenerica');
	 
		$('#fechaDeteccion').blur(function() {
			$('#catMotivInuID').focus(); 
		});

		$(':text').focus(function() {	
		 	esTab = false;
		});
		
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});
	
		$('#opeInusualID').focus(function() {	
		 	esTab = true;
		 	if(isNaN($('#catMotivInuID').val())){
		 		consultaMotivo('catMotivInuID');
		 	 }
		 	if(isNaN($('#catProcedIntID').val())){
		 		consultaProcInt('catProcedIntID');
		 	 }
		});
		
		$('#catMotivInuID').focus(function() {	
		 	esTab = true;
		 	if(isNaN($('#catProcedIntID').val())){
		 		consultaProcInt('catProcedIntID');
		 	 }
		});
		
		$('#catProcedIntID').focus(function() {	
		 	esTab = true;
		 	if(isNaN($('#catMotivInuID').val())){
		 		consultaMotivo('catMotivInuID');
		 	 }
		});
		
		$('#clavePersonaInv').focus(function() {	
		 	esTab = true;
		 	if(isNaN($('#catMotivInuID').val())){
		 		consultaMotivo('catMotivInuID');
		 	 }		 	
		 	if(isNaN($('#catProcedIntID').val())){
		 		consultaProcInt('catProcedIntID');
		 	 }
		});
		
		$('#nomPersonaInv').focus(function() {	
		 	esTab = true;
		 	if(isNaN($('#catMotivInuID').val())){
		 		consultaMotivo('catMotivInuID');
		 	 }
		 	if(isNaN($('#catProcedIntID').val())){
		 		consultaProcInt('catProcedIntID');
		 	 }
		});
		
		$('#desOperacion').focus(function() {	
		 	esTab = true;
		 	if(isNaN($('#catMotivInuID').val())){
		 		consultaMotivo('catMotivInuID');
		 	 }
		 	if(isNaN($('#catProcedIntID').val())){
		 		consultaProcInt('catProcedIntID');
		 	 }
		});
	
		$('#catMotivInuID').blur(function() {
			otroTab= false;
			if (listado == true){
				esTab = false;
				listado = false;
			}else{
				esTab=true;
			consultaMotivo(this.id);
			}
		});
		
		$('#catProcedIntID').blur(function() {
			otroTab= false;
			if (listado == true){				
				esTab = false;
				listado = false;
			}else{			
				esTab=true;
			consultaProcInt(this.id);
			}
		});
		
		$('#empInvolucrado').blur(function() {
	
			consultaEmpleado(this.id);
		});
	
		ComboCompanias();
		$.validator.setDefaults({
	            submitHandler: function(event) { 
            			$('#desOperacion').val(limpiaDeSaltosLinea('desOperacion'));
	                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','opeInusualID');
	                    $('#frecuencia2').attr("checked","1") ;
	    				$('#involucraEmpleado2').attr("checked","1") ;
	    				$('#involucraEmpleado').attr('checked',false);
	    				$('#descripcionF').hide(500);
	    				$('#desFrecuencia').hide(500);
	    				$('#empleadoInv').hide(500);
	    				$('#empInvolucrado').hide(500);
	            }
	    });	
		

		$('#nomPersonaInv').bind('keyup',function(e){
			if(esTab="false"){
				$('#clavePersonaInv').val("");
			}
	
		});
	
		 $('#catProcedIntID').bind('keyup',function(e){
			 if(this.value.length >= 2 && isNaN($('#catProcedIntID').val())){
			 var camposLista = new Array(); 
			 var parametrosLista = new Array(); 
			 camposLista[0] = "descripcion";
			 camposLista[1] = "origenDatos";
			 parametrosLista[0] = $('#catProcedIntID').val();
			 parametrosLista[1] = $('#desplegado').val();
			 listaAlfanumerica('catProcedIntID', '1', '2', camposLista, parametrosLista, 'listaProcedimientos.htm'); 
			 listado = true;
			 } 
		});
	
		 $('#clavePersonaInv').bind('keyup',function(e){				
				 var camposLista = new Array(); 
				 var parametrosLista = new Array(); 
				 camposLista[0] = "nombreCompleto";
				 camposLista[1] = "origenDatos";
				 parametrosLista[0] = $('#clavePersonaInv').val();
				 parametrosLista[1] = $('#desplegado').val();
				 lista('clavePersonaInv', '1', '33', camposLista, parametrosLista, 'listaCliente.htm'); 
				
			});
		 
		 $('#empInvolucrado').bind('keyup',function(e){
			 if(this.value.length >= 2){ 
			 var camposLista = new Array(); 
			 var parametrosLista = new Array(); 
			 camposLista[0] = "nombreCompleto";
			 camposLista[1] = "origenDatos";
			 parametrosLista[0] = $('#empInvolucrado').val();
			 parametrosLista[1] = $('#desplegado').val();
			 listaAlfanumerica('empInvolucrado', '1', '1', camposLista, parametrosLista, 'listaEmpleadosNombre.htm'); } });
	
		 $('#catMotivInuID').bind('keyup',function(e){
			 if(this.value.length >= 2 && isNaN($('#catMotivInuID').val())){
			 var camposLista = new Array();
			 var parametrosLista = new Array(); 
			 camposLista[0] = "catMotivInuID";
			 camposLista[1] = "origenDatos";
			 parametrosLista[0] = $('#catMotivInuID').val();
			 parametrosLista[1] = $('#desplegado').val();
			 listaAlfanumerica('catMotivInuID', '1', '2', camposLista, parametrosLista, 'listaMotivosInu.htm');
			 listado = true;
			 }
			});
	
		 
		 
		 $('#involucraEmpleado').click(function(){ 
			 if($('#involucraEmpleado').is(':checked')){  
                $('#involucraEmpleado2').attr('checked',false);
                $('#empleadoInv').show(500);
				$('#empInvolucrado').show(500);
				$('#empInvolucrado').focus();
				$('#empInvolucrado').val('');
			 }
		 });
  
		 $('#involucraEmpleado2').click(function(){ 
			 $('#empInvolucrado').val('');
			 		if($('#involucraEmpleado2').is(':checked')){  
			 		   $('#involucraEmpleado').attr('checked',false);
			 		   $('#empleadoInv').hide(500);
			 		   $('#empInvolucrado').hide(500);
			 }
		 });

	
		 $('#frecuencia').click(function() {		 
				$('#descripcionF').show(500);
				$('#desFrecuencia').show(500);
				$('#desFrecuencia').focus(); 
				$('#descripcionF').val('');
			});
			
		 $('#frecuencia2').click(function() {		 
				$('#descripcionF').hide(500);
				$('#desFrecuencia').hide(500);
				$('#desFrecuencia').val('');
			});
	
	
		 $('#clavePersonaInv').blur(function() {		
	  		consultaCliente(this.id);
		 });
		
		 $('#guardar').click(function() {
			$('#tipoPerSAFI').val('CTE');
			$('#tipoTransaccion').val(catTipoTransaccionCapturaOpInusuales.alta);
		 });
		
		 $('#desplegado1').change(function() {
		 	 $('#desplegado').val($('#desplegado1').val());
		 });

		 $('#desplegado1').blur(function() {
		 	 $('#desplegado').val($('#desplegado1').val());
		 	 $('#opeInusualID').focus();
		 });

		 $('#opeInusualID').blur(function() {
			 if($('#desplegado1').val()!=''){
			 	validaCapturaOpInusual(this.id); 
			 }
	  		else{
	  			alert('Seleccione un Origen Datos.');
	  			$('#desplegado1').focus();
	  		}
		 });
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
		 $('#formaGenerica').validate({
		
			 rules: {
			
				 fechaDeteccion: {
					 required: true,
					 date: true
				 },
				 
				 catMotivInuID: {
					 required: true
				 },
	
				 catProcedIntID: {
					 required: true
				 },
	
				 nomPersonaInv: {
					 required: true
				 },
			
				 desOperacion: {
					 required: true
				 },
				 
				 desFrecuencia: {
					 required: function() {return $('#frecuencia:checked').val()=='S';},
				 },
			
				 empInvolucrado: {
					 required: function() {return $('#involucraEmpleado:checked').val()=='S';},
				 }
	
			 },	
			 
			 messages: {
			
				 fechaDeteccion: {
					 required:'Especifique Fecha de Inicio.' ,
					 date: 'Fecha Incorrecta'
				 },
		
				 catMotivInuID: {
					 required: 'Especificar Motivo'
				 },
	
				 catProcedIntID: {
					 required: 'Especificar Procedimiento'
				 },
	
				 nomPersonaInv: {
					 required: 'Especificar Nombre'
				 },
			
				 desOperacion: {
					 required: 'Especifica una Descripción'
				 },
				 
				 desFrecuencia: {
					 required: 'Especifica una Descripción'
				 },
			
				 empInvolucrado: {
					 required: 'Especifica un Empleado'
				 }
			 }		
		 });
	
	
	
	//------------ Validaciones de Controles -------------------------------------
	
	
	//----------Funcion consultaMotivo---------------------//
	function consultaMotivo(idControl) {
		var jqMotivo = eval("'#" + idControl + "'");	
		var numMotivo = $(jqMotivo).val();
		var conMotivo = 2;
		var motivoBeanCon = { 
  				'catMotivInuID'	:numMotivo,	
  				'origenDatos'	:$('#desplegado').val()	  				
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numMotivo != ''  && esTab) {
			motivosInuServicio.consulta(conMotivo,
					motivoBeanCon, function(motivos) {
						if (motivos != null) {
							$('#descripcionMotivo').val(motivos.desLarga);

						} 
						else{
							alert("No Existe el Motivo");
							$('#descripcionMotivo').val('');	
		                    $('#catMotivInuID').focus();	
		                    $('#catMotivInuID').val("");	
						}
			});
		}
	}
	
	
	//----------Funcion consultaProcedimientoInterno---------------------//
	function consultaProcInt(idControl) {	
		var jqProc = eval("'#" + idControl + "'");
		var numProc = $(jqProc).val();
		var conProc = 2;
		var procBeanCon = { 
  				'catProcedIntID':numProc,		
  				'origenDatos':$('#desplegado').val()				
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numProc != ''  && esTab) {
			procInternosServicio.consulta(conProc,
					procBeanCon, function(procedimientos) {
						if (procedimientos != null) {
							$('#descripcionProceso').val(procedimientos.descripcion);
						} 
						else{
							alert("No Existe el Proceso");
							$('#descripcionProceso').val('');	
		                    $('#catProcedIntID').focus();	
		                    $('#catProcedIntID').val("");	
						}
						
			});
		}
	}
	
	// ////////////////funcion consultar empleado////////////////
	function consultaEmpleado(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);
	}	
	
	
	// ////////////////funcion consultar cliente////////////////
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		var soloNombres = '';
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(20,numCliente,$('#desplegado').val(),function(cliente) {
						if(cliente!=null){
							$('#nomPersonaInv').val(cliente.nombreCompleto);
							soloNombres = cliente.primerNombre;
							soloNombres = soloNombres==null?'':soloNombres.trim();
							soloNombres = soloNombres.trim()+' '+(cliente.segundoNombre==null?'':cliente.segundoNombre.trim());
							soloNombres = soloNombres.trim()+' '+(cliente.tercerNombre==null?'':cliente.tercerNombre.trim());
							if(soloNombres.trim()==''){
								soloNombres=$('#nomPersonaInv').val().trim();
							}
							$('#nombresPersonaInv').val(soloNombres.trim());
							$('#apPaternoPersonaInv').val(cliente.apellidoPaterno);
							$('#apMaternoPersonaInv').val(cliente.apellidoMaterno);
						} 
						else{
							alert("No Existe el Cliente");
							$('#nomPersonaInv').val('');	
		                    $('#clavePersonaInv').focus();	
		                    $('#clavePersonaInv').val("");	
							$('#nombresPersonaInv').val('');
							$('#apPaternoPersonaInv').val('');
							$('#apMaternoPersonaInv').val('');
						}
					
						
				});
			}
		}	

	
		function validaCapturaOpInusual(control) {
		var numOperacion = $('#opeInusualID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numOperacion != '' && !isNaN(numOperacion) && esTab){

			if(numOperacion==0){
		
				habilitaBoton('guardar', 'submit');
				habilitaControl('fechaDeteccion');
				habilitaControl('catMotivInuID');
				habilitaControl('catProcedIntID');
				habilitaControl('clavePersonaInv');
				habilitaControl('nomPersonaInv');
				habilitaControl('frecuencia');
				habilitaControl('frecuencia2');
				habilitaControl('desFrecuencia');
				habilitaControl('involucraEmpleado');
				habilitaControl('involucraEmpleado2');
				habilitaControl('empInvolucrado');
				habilitaControl('desOperacion');
				
				inicializaForma('formaGenerica','opeInusualID' );
				$('#frecuencia2').attr("checked","1") ;
				
				$('#involucraEmpleado2').attr("checked","1") ;
				if($('#involucraEmpleado2').is(':checked')){  
	                   $('#involucraEmpleado').attr('checked',false);
	                }
			     
		              
		          
		                
				
			   //Fecha Del sistema
			     $('#fechaDeteccion').val(obtenDia());

			     function obtenDia(){
			     	var f = new Date();
			     	dia = f.getDate();
			         mes = f.getMonth() +1;
			         anio = f.getFullYear();
			         if (dia <10){ dia = "0" + dia;}
			         if (mes <10){ mes = "0" + mes;}  
			     	
			         return anio + "-" + mes + "-" + dia;	    	    
			     }
			     
			     
   	      
			} else {
				deshabilitaBoton('guardar', 'submit'); 
				deshabilitaControl('fechaDeteccion');
				deshabilitaControl('catMotivInuID');
				deshabilitaControl('catProcedIntID');
				deshabilitaControl('clavePersonaInv');
				deshabilitaControl('nomPersonaInv');
				deshabilitaControl('frecuencia');
				deshabilitaControl('frecuencia2');
				deshabilitaControl('desFrecuencia');
				deshabilitaControl('involucraEmpleado');
				deshabilitaControl('involucraEmpleado2');
				deshabilitaControl('empInvolucrado');
				deshabilitaControl('desOperacion');
				 $('#fechaDeteccion').val("");
				 $('#catMotivInuID').val("");
				 $('#catProcedIntID').val("");
				 $('#clavePersonaInv').val("");
				 $('#nomPersonaInv').val("");
				 $('#desFrecuencia').val("");
				 $('#empInvolucrado').val("");
				 $('#desOperacion').val("");
				 $('#descripcionMotivo').val("");
				 $('#descripcionProceso').val("");
				 $('#desFrecuencia').hide();
				 $('#empInvolucrado').hide();
				 $('#descripcionF').hide();
				 $('#empleadoInv').hide();

				$('#nombresPersonaInv').val('');
				$('#apPaternoPersonaInv').val('');
				$('#apMaternoPersonaInv').val('');

				$('#frecuencia2').attr("checked","1") ;
				$('#involucraEmpleado2').attr("checked","1") ;
				if($('#involucraEmpleado2').is(':checked')){  
				       $('#involucraEmpleado').attr('checked',false);
												
				}
				}
		}
	}
		
	function ComboCompanias() {

	dwr.util.removeAllOptions('desplegado1');
	dwr.util.addOptions('desplegado1', {
		'' : 'SELECCIONAR'
	});

		companiasServicio.listaCombo(1,function(companias) {
		
				for ( var j = 0; j < companias.length; j++) {
						$('#desplegado1').append(new Option(companias[j].desplegado,companias[j].origenDatos, true, true));
						$('#desplegado1').val('').selected = true;						
				}
			
		});

		
	}
		
		
});

function limpiaDeSaltosLinea(idControl){
	var jqTexto = eval("'#" + idControl + "'");
	var texto = $(jqTexto).val();
	texto = texto.split("\n").join(" ");
	return texto;
}