$(document).ready(function() {
	esTab = true;
	var catTipoTransaccionTasaBase = {
  		'agrega':'1',
  		'modificar':'2',
  		'actualiza': '3'
	};
	
	 
	//------------ Metodos y Manejo de Eventos ----------------------------------------- 
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('cambiaValor', 'submit');
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	cargaFechaActual();
	ocultaFechaValor();

	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
      submitHandler: function(event) { 
      	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 
										'true', 'tasaBaseID');  
      }
   });	
   
   $(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTasaBase.agrega);
	});
	
	$('#modificar').click(function() { 		
		$('#tipoTransaccion').val(catTipoTransaccionTasaBase.modificar);
	});
	
	$('#cambiaValor').click(function(){
		
		$('#tipoTransaccion').val(catTipoTransaccionTasaBase.actualiza);		
		
		});

	$('#fechaValor').change(function() {
		if($('#fechaValor').val()>parametroBean.fechaAplicacion){
			alert('La Fecha no puede ser Mayor a la del Sistema.');
			$('#fechaValor').focus();
			$('#fechaValor').val(parametroBean.fechaAplicacion);
		}
	});
	
	
	$('#agrega').attr('tipoTransaccion', '1');
	$('#modificar').attr('tipoTransaccion', '2');
	$('#cambiaValor').attr('tipoTransaccion', '3');
	
	$('#tasaBaseID').blur(function() {
  		validaTasaBase(this.id);  			 
	});
	
	$('#tasaBaseID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "nombre";
			
			parametrosLista[0] = $('#tasaBaseID').val();
						
			lista('tasaBaseID', '2', '1', camposLista, parametrosLista, 'tasaBaseLista.htm');
		}				       
	});	
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
				
		rules: {     
			tasaBaseID 		: 	'required',        
			descripcion		:  {
				required 	: 	true,
				minlength	: 	5
			},    
			nombre 	:  {
				required 	: 	true
			},
			fechaValor :{
				required	: 	true, 
			},
			valor :{
				required	: 	true, 
			},
			claveCNBV: {
				digits		: true
			}
		},
		
		messages: {
			tasaBaseID			: 'Especifique tasa Base',        
			descripcion		: {
				required	: 'Especifique la descripcion',
				minlength: 'Minimo 5 caracteres'
			},    
			nombre		:{
				required	: 'Especifique el nombre'
			},
			fechaValor 	:{
				required 	: 'Especifique la Fecha.'
			},
			claveCNBV:{
				digits		: 'Ingrese una clave valida'
			},
			valor: {
				required	: 'Ingrese un valor ', 
			}

		}		
	});
	
	
	//------------ Validaciones de Controles -------------------------------------


	function validaTasaBase(idControl) {
		var jqTasa  = eval("'#" + idControl + "'");
		var tasaBase = $(jqTasa).val();			
		var TasaBaseBeanCon = {
  			'tasaBaseID':tasaBase
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(tasaBase != '' && !isNaN(tasaBase) && esTab){
			
			if(tasaBase=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('cambiaValor', 'submit');
				inicializaForma('formaGenerica','tasaBaseID');
				ocultaFechaValor();
				cargaFechaActual();
				
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modificar','submit');
				habilitaBoton('cambiaValor', 'submint');
				tasasBaseServicio.consulta(1,TasaBaseBeanCon ,function(tasasBaseBean) {
						if(tasasBaseBean!=null){
							dwr.util.setValues(tasasBaseBean);															
							deshabilitaBoton('agrega', 'submit');
							cargaFechaActual();
							muestraFechaValor();
						}else{
							inicializaForma('formaGenerica','tasaBaseID');
							alert("No Existe la Tasa Base.");
						
   							deshabilitaBoton('agrega', 'submit');
								$('#tasaBaseID').focus();
								$('#tasaBaseID').select();											
							}
				});
			}									
		}
	}

	$('#valor').blur(function(){

		if($('#valor').val().length > 15){

			$('#valor').val('0.0000');

			$('#valor').focus();

			mensajeSis('El valor ingresado supera el valor máximo permitido \(99,999,999.9999\)')
		}
	});

	function ocultaFechaValor(){
		$('#lblFechaValor').hide();
		$('#fechaValor').hide();
		$('#tdFechaValor').hide();
	}

	function muestraFechaValor(){
		$('#lblFechaValor').show();
		$('#fechaValor').show();
		$('#tdFechaValor').show();
	}
	
});

	function cargaFechaActual(){
		$('#fechaValor').val(parametroBean.fechaAplicacion);
	}
