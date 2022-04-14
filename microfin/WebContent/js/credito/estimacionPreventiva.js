$(document).ready(function() {
		esTab = true;
		var parametroBean = consultaParametrosSession();
	//Definicion de Constantes y Enums  
	var  catTipoTraEstima = {
		'principal'		:1
	}
	var catTipoConsultaEstima = { 
  		'principal'		: 1,
  		'consultaFecha' : 4
	};
	
	//------------ Metodos y Manejo de Eventos -----------	
	$(':text').focus(function() {
	 	esTab = false;
	});
	
	agregaFormatoControles('formaGenerica');
	consultaFecha();
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#generar').click(function (){
		$('#tipoTransaccion').val(catTipoTraEstima.principal);
		
	});
	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','fechaCorte');
			$('input:radio[name=aplicacionContable]')[1].checked = true;
		}
    });
	
	$('#fechaCorte').change(function(){
		var fechaCorte = $('#fechaCorte').val()
		var estimacionBean = {
			'fechaCorte' : fechaCorte
		};
		estimacionPreventivaServicio.consulta(estimacionBean, catTipoConsultaEstima.consultaFecha, function(data){
			if (data != null){
				if(data.fechaCorte == fechaCorte){
					habilitaBoton('generar', 'submit');
				}else{
					alert ('La fecha seleccionada no es valida, Fecha sugerida: '+ data.fechaCorte)
					$('#fechaCorte').val(data.fechaCorte)
					habilitaBoton('generar', 'submit');
				}
			}
		});
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			fechaCorte: {
				required: true
			}
		},
		
		messages: {
			fechaCorte: {
				required: 'Especificar Fecha de Estimacion'
			}
		}
	});
	//------------ Validaciones de Controles -------------------------------------
	
	function consultaFecha(){
		var estimacionBean = {
			'fechaCorte' : parametroBean.fechaAplicacion
		};
		estimacionPreventivaServicio.consulta(estimacionBean, catTipoConsultaEstima.consultaFecha, function(data){
			if (data != null){
				$('#fechaCorte').val(data.fechaCorte)
			}
		});
	}
});