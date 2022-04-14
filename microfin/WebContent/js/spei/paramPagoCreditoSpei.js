	var clienteEspecifico = 0;
	
	$(document).ready(function() {
		esTab = true;

		var parametrosBean = consultaParametrosSession();
		//Definicion de Constantes y Enums
		var catTipoTransaccion = {
				'modificar':'1'
		};

		//------------ Metodos y Manejo de Eventos -----------------------------------------
		
		$(':text').focus(function() {
			esTab = false;
		});

		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});


		$.validator.setDefaults({
			submitHandler: function(event) {
				grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','false','false','funcionExitoAutoriza','funcionErrorAutoriza');

			}
		});

		$('#guardar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccion.modificar);

		});

		consultaClienteEspecifico();

		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				aplicaPagAutCre : 'required',
				enCasoTieneExiCre : 'required',
				enCasoSobrantePagCre : 'required',

			},
			messages: {
				aplicaPagAutCre : 'Campo requerido',
				enCasoTieneExiCre : 'Campo requerido',
				enCasoSobrantePagCre : 'Campo requerido',

			}
		});



		//------------ Validaciones de Controles -------------------------------------


	});




	function consultaParamPagCredito(empresaID) {
			
		
		var ParamPagCreditoBean = {
			'numEmpresaID' : empresaID
		};
		setTimeout("$('#cajaLista').hide();", 200);

		paramPagoCreditoSpei.consulta(1, ParamPagCreditoBean, function(paramPagCredito) {
			if(paramPagCredito != null) {
				if(paramPagCredito.aplicaPagAutCre=="S"){
					$('#aplicaPagAutCre').attr("checked", true);
				}else{
					$('#aplicaPagAutCre1').attr("checked", true);
				}
				if(paramPagCredito.enCasoTieneExiCre=="A"){
					$('#enCasoTieneExiCre').attr("checked", true);
				}else{
					$('#enCasoTieneExiCre1').attr("checked", true);
				}
				if(paramPagCredito.enCasoSobrantePagCre=="A"){
					$('#enCasoSobrantePagCre').attr("checked", true);
				}else{
					$('#enCasoSobrantePagCre1').attr("checked", true);
				}
				
			} 
		});
	}
	function consultaClienteEspecifico(){
		var tipoConsulta = 13;
		var bean = {
				'empresaID'     : 1
			};	
		paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
				if (parametro != null){
					$("#numEmpresaID").val(parametro.valorParametro);	
					consultaParamPagCredito(parametro.valorParametro);
	
				}else{
					$("#numEmpresaID").val(0);	
				}
	
		}});
	}
	
	function funcionExitoAutoriza (){
		consultaParamPagCredito($("#numEmpresaID").val());
		
	}

	function funcionErrorAutoriza (){
		consultaParamPagCredito($("#numEmpresaID").val());
	}
