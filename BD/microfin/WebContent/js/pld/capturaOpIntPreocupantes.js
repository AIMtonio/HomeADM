$(document).ready(function() {
		esTab = true;
		otra = false;
		otroTab = false;
		var lista = false;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCapturaOpIntPreocupantes = {  
  		'alta':2
		};
	
	var catTipoListaPersonaInv = {
			'filtrada':1,
			'vacia':2,
			'filtroA':3,
			'filtroB':4
		};
	

	
		//------------ Msetodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('guardar', 'submit');
	 agregaFormatoControles('formaGenerica');

		$('#fechaDeteccion').blur(function() {
			$('#catMotivPreoID').focus(); 
		});


	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	ComboCompanias();
		
	 $('#desplegado1').change(function() {
	 	 $('#desplegado').val($('#desplegado1').val());
	 });

	 $('#desplegado1').blur(function() {
	 	 $('#desplegado').val($('#desplegado1').val());
	 	$('#opeInterPreoID').focus();
	 });
	$('#opeInterPreoID').focus(function() {	
	 	esTab = true;
		 deshabilitaBoton('guardar', 'submit');
		 if(isNaN($('#catMotivPreoID').val())){
		 		consultaMotivo('catMotivPreoID');
		 	 }
		 if(isNaN($('#catProcedIntID').val())){
		 		consultaProcInt('catProcedIntID');
		 	 }
	});
	
	$('#catMotivPreoID').focus(function() {	
	 	esTab = true;
	 	if(isNaN($('#catProcedIntID').val())){
	 		consultaProcInt('catProcedIntID');
	 	 }
	});
	
	$('#catProcedIntID').focus(function() {	
	 	esTab = true;
	 	if(isNaN($('#catMotivPreoID').val())){
	 		consultaMotivo('catMotivPreoID');
	 	 }

	});
	
	$('#clavePersonaInv').focus(function() {	
	 	esTab = true;
	 	if(isNaN($('#catMotivPreoID').val())){
	 		consultaMotivo('catMotivPreoID');
	 	 }
	 	if(isNaN($('#catProcedIntID').val())){
	 		consultaProcInt('catProcedIntID');
	 	 }
	});
	
	$('#nomPersonaInv').focus(function() {	
	 	esTab = true;
	 	if(isNaN($('#catMotivPreoID').val())){
	 		consultaMotivo('catMotivPreoID');
	 	 }
	 	if(isNaN($('#catProcedIntID').val())){
	 		consultaProcInt('catProcedIntID');
	 	 }
	});
	
	$('#desOperacion').focus(function() {	
	 	esTab = true;
	 	if(isNaN($('#catMotivPreoID').val())){
	 		consultaMotivo('catMotivPreoID');
	 	 }
	 	if(isNaN($('#catProcedIntID').val())){
	 		consultaProcInt('catProcedIntID');
	 	 }
	});
	
	$('#guardar').focus(function() {
		esTab = true;
	 	if(isNaN($('#catMotivPreoID').val())){
	 		consultaMotivo('catMotivPreoID');
	 	 }
	 	if(isNaN($('#catProcedIntID').val())){
	 		consultaProcInt('catProcedIntID');
	 	 }
	});

	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#categoriaID').blur(function() {
		consultaCategoria(this.id);
		otra=true;
	});
	
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
		otra=false;
	});

	$('#clavePersonaInv').blur(function() {
		consultaEmpleado(this.id);
		otra=false;
	});
	
	$('#catMotivPreoID').blur(function() {
		otroTab= false;
		if (lista == true){
			esTab = false;
			lista = false;
		}else{
			esTab=true;
		consultaMotivo(this.id);
		}
	});
	
	$('#catProcedIntID').blur(function() {
		otroTab= false;
		if (lista == true){
			esTab = false;
			lista = false;
		}else{
			esTab=true;
		consultaProcInt(this.id);
		}
	});
	
	$.validator.setDefaults({
            submitHandler: function(event) { 
            		$('#desOperacion').val(limpiaDeSaltosLinea('desOperacion'));
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','opeInterPreoID');
                    $('#frecuencia2').attr("checked","1") ;
    				$('#involucraCliente2').attr("checked","1") ;
    				$('#involucraCliente').attr('checked',false);
    				$('#descripcionF').hide(500);
    				$('#desFrecuencia').hide(500);
    				$('#clienteInv').hide(500);
    				$('#cteInvolucrado').hide(500);
            }
    });	
	

	$('#nomPersonaInv').bind('keyup',function(e){
		if(esTab="false"){
			$('#clavePersonaInv').val("");
			$('#categoriaID').val("");
			$('#sucursalID').val("");
			$('#descripcionCategoria').val("");
			$('#descripcionSucursal').val("");
		
		}
		otra=false;
	});
	
	$('#categoriaID').bind('keyup',function(e){
		if(esTab==false){
			$('#clavePersonaInv').val("");
			$('#nomPersonaInv').val("");
			$('#sucursalID').val("");
			$('#descripcionCategoria').val("");
			$('#descripcionSucursal').val("");
			
		}
		if(this.value.length >= 2){ 
			 var camposLista = new Array(); var
			 parametrosLista = new Array(); camposLista[0] = "descripcion";
			 parametrosLista[0] = $('#categoriaID').val();
			 listaAlfanumerica('categoriaID', '1', '1', camposLista, parametrosLista, 'listaCategorias.htm'); 
		}

	});

	
	$('#sucursalID').bind('keyup',function(e){
		$('#descripcionSucursal').val("");
		if(esTab="false" && this.value.length <1 && otra == false){
			$('#clavePersonaInv').val("");
			$('#nomPersonaInv').val("");
			$('#descripcionCategoria').val("");
			$('#categoriaID').val("");
			
		}
		
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');

	});

	
	$('#catMotivPreoID').bind('keyup',function(e){
		 if(this.value.length >= 2 && isNaN($('#catMotivPreoID').val())){
		 var camposLista = new Array(); 
		 var parametrosLista = new Array(); 
		 camposLista[0] = "catMotivPreoID";
		 camposLista[1] = "origenDatos";
		 parametrosLista[0] = $('#catMotivPreoID').val();
		 parametrosLista[1] = $('#desplegado').val();
		 listaAlfanumerica('catMotivPreoID', '2', '2', camposLista, parametrosLista, 'listaMotivos.htm'); 
		 lista = true;
		 }
	});

	
	
		
		 $('#catProcedIntID').bind('keyup',function(e){
			 if(this.value.length >= 2 && isNaN($('#catProcedIntID').val())){
			 var camposLista = new Array(); 
			 var parametrosLista = new Array(); 
			 camposLista[0] = "descripcion";
			 parametrosLista[0] = $('#catProcedIntID').val();
			 camposLista[1] = "origenDatos";
			 parametrosLista[1] =$('#desplegado').val();
			 listaAlfanumerica('catProcedIntID', '1', '2', camposLista, parametrosLista, 'listaProcedimientos.htm'); 
			 lista = true;
			 }  
		 });
				 
		
		 
		 $('#clavePersonaInv').bind('keyup',function(e){
			 if(this.value.length >= 2){ 
				 var camposLista = new Array(); 
				 var parametrosLista = new Array(); 
				 var tipoLista =0;
				 if(parseInt($('#categoriaID').val())>0 && parseInt($('#sucursalID').val())>0){
					 tipoLista = catTipoListaPersonaInv.filtrada;
				 }else{
					 if(parseInt($('#categoriaID').val())>0){
						 tipoLista = catTipoListaPersonaInv.filtroA;

					 }
					 else{
						 if(parseInt($('#sucursalID').val())>0){
							 tipoLista = catTipoListaPersonaInv.filtroB;

						 }
						 else{
					 tipoLista = catTipoListaPersonaInv.vacia;

					 }}
				 }
				 camposLista[0] = "categoriaID";
	             camposLista[1] = "sucursalID";
	             camposLista[2] = "nomPersonaInv";
	             camposLista[3] = "origenDatos";
	             parametrosLista[0] = $('#categoriaID').val();
                 parametrosLista[1] = $('#sucursalID').val();
	             parametrosLista[2] = $('#clavePersonaInv').val();
	             parametrosLista[3] = $('#desplegado').val();
	
				 listaAlfanumerica('clavePersonaInv', '1', tipoLista, camposLista, parametrosLista, 'listaPersonaInv.htm'); }
			 
		 });
		 
		 $('#involucraCliente').click(function(){ 
			    if($('#involucraCliente').is(':checked')){  
			       $('#involucraCliente2').attr('checked',false);
			       $('#clienteInv').show(500);
			       $('#cteInvolucrado').show(500);
			       $('#cteInvolucrado').focus();
			       $('#cteInvolucrado').val('');
			    }
		 });
		 
		$('#involucraCliente2').click(function(){ 
				$('#cteInvolucrado').val('');
					if($('#involucraCliente2').is(':checked')){  
					   $('#involucraCliente').attr('checked',false);
					   $('#clienteInv').hide(500);
					   $('#cteInvolucrado').hide(500);
			        }
		});
			
	
	
			
	
	$('#frecuencia').click(function() {		 
		$('#descripcionF').show(500);
		$('#desFrecuencia').show(500);
		$('#desFrecuencia').focus(); 
		$('#desFrecuencia').val('');
	});
	
	$('#frecuencia2').click(function() {		 
		$('#descripcionF').hide(500);
		$('#desFrecuencia').hide(500);
		$('#desFrecuencia').val('');
	});
		
	
	
	
	$('#guardar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCapturaOpIntPreocupantes.alta);
	});
	
	
	$('#opeInterPreoID').blur(function() { 
		if($('#desplegado1').val()!=''){
			esTab= true;
	  		validaCapturaOpIntPreocupante(this.id); 
		}
		else{
			alert('Seleccioné un Origen de Datos.');
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
			catMotivPreoID: {
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
			
			cteInvolucrado: {
				required: function() {return $('#involucraCliente:checked').val()=='S';},
			}
			
			
	
		},		
		messages: {
			
			fechaDeteccion: {
		        required:'Especifique Fecha de Inicio..' ,
		        date: 'Fecha Incorrecta'
			},
		
			catMotivPreoID: {
				required: 'Especificar Motivo'
			},
	
			catProcedIntID: {
				required: 'Especificar Procedimiento'
			},
	
			nomPersonaInv: {
				required: 'Especificar Nombre'
			},
			
			desOperacion: {
				required: 'Especifica una Descripcion'
			},
			
			desFrecuencia: {
				required: 'Especifica una Descripcion'
			},
			
			cteInvolucrado: {
				required: 'Especifica un Cliente'
			}
		}		
	});
	
	
	
	//------------ Validaciones de Controles -------------------------------------
	
	
	//----------Funcion consultaCategoria---------------------//
	function consultaCategoria(idControl) {
		var jqCategoria = eval("'#" + idControl + "'");
		var numCategoria = $(jqCategoria).val();
		var conCategoria = 3;
		var categoriaBeanCon = { 
  				'categoriaID':numCategoria		  				
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCategoria != ''  && esTab) {
			puestosServicio.consulta(conCategoria,
					categoriaBeanCon, function(categorias) {
						if (categorias != null) {
							$('#descripcionCategoria').val(categorias.descripcionCategoria);
						} 
						else{
							alert("No Existe el Tipo de Persona "+ numCategoria);
							$('#descripcionCategoria').val('');	
		                    $('#categoriaID').focus();	
		                    $('#categoriaID').val("");
						}
					});
		}
	}
	
	
	//----------Funcion consultaMotivo---------------------//
	function consultaMotivo(idControl) {
		var jqMotivo = eval("'#" + idControl + "'");
		var numMotivo = $(jqMotivo).val();
		var conMotivo = 2;
		var motivoBeanCon = { 
  				'catMotivPreoID':numMotivo,	
  				'origenDatos':$('#desplegado').val()
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numMotivo != ''  && esTab) {
			motivosPreoServicio.consulta(conMotivo,
					motivoBeanCon, function(motivos) {
						if (motivos != null) {
							$('#descripcionMotivo').val(motivos.desLarga);

						} 
						else{
							alert("No Existe el Motivo "+ numMotivo);
							$('#descripcionMotivo').val('');	
		                     $('#catMotivPreoID').focus();	
		                     $('#catMotivPreoID').val("");
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
							alert("No Existe el Proceso "+ numProc);
							$('#descripcionProceso').val('');	
		                     $('#catProcedIntID').focus();	
		                     $('#catProcedIntID').val("");
						}
					});
		}
	}
	
	

	// ////////////////funcion consultar sucursal////////////////
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
	
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
			sucursalesServicio.consultaSucursal(conSucursal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#descripcionSucursal').val(sucursal.nombreSucurs);

						} 
						else{
							alert("No Existe la sucursal "+ numSucursal);
							$('#descripcionSucursal').val('');	
		                     $('#sucursalID').focus();	
		                     $('#sucursalID').val("");
						}
						
					});
		}
	}
	
	
	// ////////////////funcion consultar empleado////////////////
	function consultaEmpleado(idControl) {
		var jqEmpleado = eval("'#" + idControl + "'");
		var numEmpleado = $(jqEmpleado).val();
		var conEmpleado = 4;
		var empleadoBeanCon = { 
  				'empleadoID':numEmpleado,
  				'origenDatos':$('#desplegado').val()
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEmpleado != '' && !isNaN(numEmpleado) && esTab) {
			empleadosServicio.consulta(conEmpleado,
					empleadoBeanCon, function(empleados) {
						if (empleados != null) {
							$('#nomPersonaInv').val(empleados.nombreCompleto);

						} 
						else{
							alert("No Existe el Empleado "+ numEmpleado);
							$('#nomPersonaInv').val('');	
		                     $('#clavePersonaInv').focus();	
		                     $('#clavePersonaInv').val("");
						}
					});
		}
	}	
	
	
	
	// ////////////////funcion ocultar lista////////////////
	function ocultaLista(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);
	}
	
		function validaCapturaOpIntPreocupante(control) {
		var numOperacion = $('#opeInterPreoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numOperacion != '' && !isNaN(numOperacion) && esTab){

			if(numOperacion==0){
		
				habilitaBoton('guardar', 'submit');
				habilitaControl('fechaDeteccion');
				habilitaControl('catMotivPreoID');
				habilitaControl('categoriaID');
				habilitaControl('sucursalID');
				habilitaControl('catProcedIntID');
				habilitaControl('clavePersonaInv');
				habilitaControl('nomPersonaInv');
				habilitaControl('frecuencia');
				habilitaControl('frecuencia2');
				habilitaControl('desFrecuencia');
				habilitaControl('involucraCliente');
				habilitaControl('involucraCliente2');
				habilitaControl('cteInvolucrado');
				habilitaControl('desOperacion');
				
				inicializaForma('formaGenerica','opeInterPreoID' );
				$('#frecuencia2').attr("checked","1") ;
				$('#involucraCliente2').attr("checked","1") ;
				
			    
		                if($('#involucraCliente').is(':checked')){  
		                        $('#involucraCliente2').attr('checked',false);
		                }
		          
		              
		                    if($('#involucraCliente2').is(':checked')){  
		                            $('#involucraCliente').attr('checked',false);
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
				deshabilitaControl('catMotivPreoID');
				deshabilitaControl('categoriaID');
				deshabilitaControl('sucursalID');
				deshabilitaControl('catProcedIntID');
				deshabilitaControl('clavePersonaInv');
				deshabilitaControl('nomPersonaInv');
				deshabilitaControl('frecuencia');
				deshabilitaControl('frecuencia2');
				deshabilitaControl('desFrecuencia');
				deshabilitaControl('involucraCliente');
				deshabilitaControl('involucraCliente2');
				deshabilitaControl('cteInvolucrado');
				deshabilitaControl('desOperacion');
				 $('#fechaDeteccion').val("");
				 $('#catMotivPreoID').val("");
				 $('#categoriaID').val("");
				 $('#sucursalID').val("");
				 $('#catProcedIntID').val("");
				 $('#clavePersonaInv').val("");
				 $('#nomPersonaInv').val("");
				 $('#desFrecuencia').val("");
				 $('#cteInvolucrado').val("");
				 $('#desOperacion').val("");
				 $('#descripcionMotivo').val("");
				 $('#descripcionProceso').val("");
				 $('#desFrecuencia').hide();
				 $('#cteInvolucrado').hide();
				 $('#descripcionF').hide();
				 $('#clienteInv').hide();
				 $('#frecuencia2').attr("checked","1") ;
				 $('#involucraCliente2').attr("checked","1") ;
				 	if($('#involucraCliente2').is(':checked')){  
				       $('#involucraCliente').attr('checked',false);
				 	}
												
			}
		}
	}
		
		
		function ComboCompanias() {

			dwr.util.removeAllOptions('desplegado1');
			dwr.util.addOptions('desplegado1', {
				'' : 'SELECCIONA'
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