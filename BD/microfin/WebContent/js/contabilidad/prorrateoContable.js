$(document).ready(function(){
	inicializaForma('formaGenerica');
	esTab=true;	
	var Enum_Tran_Pro={
			'agregar':1,
			'modificar':2		
	};	
	$(':text').focus(function(){
		esTab=false;
	});
	
	$(':text').bind('keydown',function(e){
		if(e.which == 9 && !e.shifkey){
			esTab=true;
		}
	});
	
	deshabilitaBoton('agrega');
	deshabilitaBoton('modifica');
	
	$('#prorrateoID').bind('keyup',function(){
			lista('prorrateoID','2','1','nombreProrrateo',$('#prorrateoID').val(),'prorrateoContableLista.htm');
	});
	
	$('#prorrateoID').blur(function(){
		if($('#prorrateoID').val()!='' && !isNaN($('#prorrateoID').val())){
			if($('#prorrateoID').val()==0){
				deshabilitaBoton('modifica');
				habilitaBoton('agrega');
				limpiarCampos();
				var params={};
				params['tipoConsulta']=2;
				params['prorrateoID']=$('#prorrateoID').val();
				consultaGridProrrateo(params);
			}else{
				deshabilitaBoton('agrega');
				habilitaBoton('modifica');
				consultaMetodoProrrateo(this);
			}
		}	
	});
	
	$('#agrega').click(function(){
		$('#tipoTransaccion').val(Enum_Tran_Pro.agregar);
	});
	
	$('#modifica').click(function(){
		$('#tipoTransaccion').val(Enum_Tran_Pro.modificar);
	});
	
	$.validator.setDefaults({
			submitHandler: function(event){
				if(parseFloat($('#totalPorcentajes').asNumber())!=100){
					$('#selecTodos').attr('checked',false);
					alert("La Suma de los Porcentajes de los Centros de Costo debe ser 100%.");	
				}else{
					grabaFormaTransaccionRetrollamada(event,'formaGenerica','contenedorForma',
				 'mensaje','true','prorrateoID','exitoTransaccionPro','falloTransaccionPro');
				}
			}
	});
	
	$('#formaGenerica').validate({
			rules: {
				prorrateoID:{
					required: 	true
				},
				nombreProrrateo:{
					required:	true
				},
				estatus:{
					required: 	true
				}
			},
			messages:{
				prorrateoID:{
					required:	'Especifique el Número de Prorrateo'
				},
				nombreProrrateo:{
					required:	'Especifique el Nombre'
				},
				estatus:{
					required: 'Especifique el Estatus'
				}
			}
	});
	
	function consultaMetodoProrrateo(jqcontrol){		
		var evalControl=eval("'#"+jqcontrol.id+"'");		
		var valorControl=$(evalControl).val();		
		var tipoLista=1;
		prorrateoBean={
				'prorrateoID' : valorControl
		};
		prorrateoContableServicio.consulta(tipoLista,prorrateoBean,function(prorrateo){
				if(prorrateo!=null){
					dwr.util.setValues(prorrateo);
					var params={};
					params['tipoConsulta']=2;
					params['prorrateoID']=valorControl;
					consultaGridProrrateo(params);
				}else{
					alert("El Método de Prorrateo no Existe.");
					$('#prorrateoID').val('');
					$('#nombreProrrateo').val('');
					$('#descripcion').val('');
					$('#estatus').val('');
					$('#prorrateoID').focus();
					deshabilitaBoton('agrega');
					deshabilitaBoton('modifica');
					$('#gridSucursProrrateo').hide(500);
				}
		});
	}
	
	function consultaGridProrrateo(params){
		$('#gridSucursProrrateo').hide();				
		$.post("prorrateoContableGrid.htm", params,function(data){
			if (data.length > 0){
				$('#gridSucursProrrateo').html(data);
				$('#gridSucursProrrateo').show(500);
			}
		});
	}
	function limpiarCampos(){		
		$('#nombreProrrateo').val('');
		$('#descripcion').val('');
		$('#estatus').val('A');
	}
});
function exitoTransaccionPro(){
	inicializaForma('formaGenerica','prorrateoID');
	deshabilitaBoton('agrega');
	deshabilitaBoton('modifica');	
	$('#gridSucursProrrateo').hide(500);
}
function falloTransaccionPro(){
	
}