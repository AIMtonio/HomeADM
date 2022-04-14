$(document).ready(function() {
	esTab = true;
	$("#empresaID").focus();
	//en caso de necesitar valores de seion 
	//parametros = consultaParametrosSession();
	var tipoTransaccionParametros = {
		'modificacion' : '1'			
	};	

	// var	esTab = true;
	var tipoTransaccionGrid= {
			'alta' : '2',
			'baja' : '3'		
		};
	
	var tipoTransaccionGridPer= {
			'graba' : '1'
		};
	
	
	
	/*pone tap falso cuando toma el foco input text */
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	/*pone tab en verdadero cuando se presiona tab */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	
	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	
	/*esta funcion esta en forma.js */
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('btnagregar','submit');
	deshabilitaBoton('btnGrabarAsambleas','submit');
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('formaGenerica1');
	agregaFormatoControles('formaGenerica2');

	/*llena los combos que muestran los tipos de cuenta */
	consultaTiposCuenta();
	/*llena el combo que muestra los tipos de apoyo escolar segun el ciclo(nivel escolar) */
	consultaTiposApoyo();
	
	/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({		
	    submitHandler: function(event) { 
		var transacion = $('#tipoTransaccion').val();
		var transacionGridPer = $('#tipoTransaccionGridPer').val();
		var transacionGrid = $('#tipoTransaccionGrid').val();

		if(transacion  == tipoTransaccionParametros.modificacion){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','empresaID','funcionExitoParamCaja','funcionFalloParamCaja'); 
		} else {
				if(transacionGrid == tipoTransaccionGrid.alta){
					var gradoEsc = $('#apoyoEscCicloID').val();
					if(gradoEsc !=''){
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje','true','apoyoEscCicloID','funcionExitoGridApoyoEsc','funcionFalloGridApoyoEsc');
					} else {
						alert('Especificar el Grado Escolar');
						$('#apoyoEscCicloID').focus();
						return false;
					}					
				} else {
					if(transacionGridPer == tipoTransaccionGridPer.graba){
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','usuarioID','funcionExitoParamCaja','funcionFalloParamCaja');
					}
				}
			}
		}

	 });
	
	/*asigna el tipo de transaccion */
	$('#modificar').click(function() {	
		$('#tipoTransaccion').val(tipoTransaccionParametros.modificacion);
		$('#tipoTransaccionGridPer').val(0);
		$('#tipoTransaccionGrid').val(0);
		guardarUsuarios();
	});
	$('#agrega').click(function() {		
		$('#tipoTransaccionGrid').val(tipoTransaccionGrid.alta);
		$('#tipoTransaccion').val(0);
		$('#tipoTransaccionGridPer').val(0);
		
	});
	
	$('#btnGrabarAsambleas').click(function() {		
		$('#tipoTransaccionGrid').val(0);
		$('#tipoTransaccion').val(0);
		$('#tipoTransaccionGridPer').val(tipoTransaccionGridPer.graba);
	});
	
	/*busca y lista las empresas */
	$('#empresaID').bind('keyup',function(e){	
		if(this.value.length >= 2){ 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreInstitucion";
		parametrosLista[0] = $('#empresaID').val();
		lista('empresaID', '1', '1', camposLista, parametrosLista, 'listaParametrosSis.htm');	
		}
	});
	
	$('#empresaID').blur(function() {
		validaEmpresaID(this);
	});
	
	
	
	/*busca y lista los tipos de cuentas contables */
	$('#haberExSocios').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#haberExSocios').val();
			listaAlfanumerica('haberExSocios', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	/*obtiene la descripcion de la cuenta contable seleccionada */
	$('#haberExSocios').blur(function() {
			maestroCuentasDescripcion(this.id,'haberExSociosDes','haberExSocios');
			
		});


	
	$('#ctaProtecCta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaProtecCta').val();
			listaAlfanumerica('ctaProtecCta', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#ctaProtecCta').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaProtecCtaDes','ctaProtecCta');
	});

	
	$('#ctaProtecCre').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaProtecCre').val();
			listaAlfanumerica('ctaProtecCre', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#ctaProtecCre').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaProtecCreDes','ctaProtecCre');
	});

	
	$('#ctaContaPROFUN').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaContaPROFUN').val();
			listaAlfanumerica('ctaContaPROFUN', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#ctaContaPROFUN').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaContaPROFUNDes','ctaContaPROFUN');
	});

	$('#ctaContaSRVFUN').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaContaSRVFUN').val();
			listaAlfanumerica('ctaContaSRVFUN', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#ctaContaSRVFUN').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaContaSRVFUNDes','ctaContaSRVFUN');
	});


	$('#ctaContaApoyoEsc').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaContaApoyoEsc').val();
			listaAlfanumerica('ctaContaApoyoEsc', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#ctaContaApoyoEsc').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaContaApoyoEscDes','ctaContaApoyoEsc');
	});


	

	
	/*Consulta los perfiles (tipo de roles) */
	$('#perfilCancelPROFUN').bind('keyup',function(e){
		if(this.value.length >= 2){ 
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#perfilCancelPROFUN').val();
			lista('perfilCancelPROFUN', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');	
		}
	});	

	$('#perfilCancelPROFUN').blur(function() {
		consultaRoles('perfilCancelPROFUN','perfilCancelPROFUNDes');		
	});
	
	$('#perfilAutoriProtec').bind('keyup',function(e){
		if(this.value.length >= 2){ 
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#perfilAutoriProtec').val();
			lista('perfilAutoriProtec', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');	
		}
	});	
	
	$('#perfilAutoriProtec').blur(function() {
		consultaRoles('perfilAutoriProtec','perfilAutoriProtecDes');		
	});
	
	$('#perfilAutoriSRVFUN').bind('keyup',function(e){
		if(this.value.length >= 2){ 
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#perfilAutoriSRVFUN').val();
			lista('perfilAutoriSRVFUN', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');	
		}
	});	

	$('#perfilAutoriSRVFUN').blur(function() {
		consultaRoles('perfilAutoriSRVFUN','perfilAutoriSRVFUNDes');		
	});
	
	$('#rolCancelaCheque').bind('keyup',function(e){
		if(this.value.length >= 2){ 
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#rolCancelaCheque').val();
			lista('rolCancelaCheque', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');	
		}
	});	
	
	$('#rolCancelaCheque').blur(function() {
		consultaRoles('rolCancelaCheque','desRolCancelaCheque');		
	});
	
	$('#rolAutoApoyoEsc').bind('keyup',function(e){
		if(this.value.length >= 2){ 
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#rolAutoApoyoEsc').val();
			lista('rolAutoApoyoEsc', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');	
		}
	});
	
	$('#rolAutoApoyoEsc').blur(function() {
		consultaRoles('rolAutoApoyoEsc','rolAutoApoyoEscDes');		
	});
	
	
	$('#ejecutivoFR').bind('keyup',function(e){
		if(this.value.length >= 2){ 
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#ejecutivoFR').val();
			lista('ejecutivoFR', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');	
		}
	});	
	
	$('#ejecutivoFR').blur(function() {
		consultaRoles('ejecutivoFR','ejecutivoFRDes');		
	});
	
	/*busca y lista los tipos de cuentas contables */
	$('#ctaContaPerdida').bind('keyup',function(e){
		if($('#ctaContaPerdida').val().length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaContaPerdida').val();
			listaAlfanumerica('ctaContaPerdida', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	/*obtiene la descripcion de la cuenta contable seleccionada */
	$('#ctaContaPerdida').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaContaPerdidaDes');
	});
	/*busca y lista los gastos alimenticios */


	$('#idGastoAlimenta').bind('keyup',function(e){	
		lista('idGastoAlimenta', '2', '1', 'descripcion',$('#idGastoAlimenta').val(), 'listaGastosDatoSocio.htm');	
		}
	);
	
	$('#idGastoAlimenta').blur(function() {
		consultaGatosSocioe(this.id);
	});


	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({			
			rules: {			
				empresaID: {
					required: true,
					minlength: 1,
					number: true
				},
				ctaOrdinaria: {
					required: true
				},
				tipoCtaProtec:{
					required: true
				},
				montoMaxProtec:{
					required: true,
					number: true
				},
				montoPROFUN:{
					required: true,
					number: true
				},
				aporteMaxPROFUN:{
					required: true,
					number: true
				},
				maxAtraPagPROFUN:{
					required: true,
					number: true
				},
				
				haberExSocios:{
					required: true
				},
				ctaProtecCta:{
					required: true
				},
				ctaProtecCre:{
					required: true
				},
				ctaContaPROFUN:{
					required: true
				},
				perfilAutoriSRVFUN:{
					required: true
				},
				ctaContaSRVFUN:{
					required: true
				},
				montoApoyoSRVFUN:{
					required: true,
					number: true
				},
				monApoFamSRVFUN:{
					required: true,
					number: true
				},
				edadMaximaSRVFUN:{
					required: true,
					number: true
				},
				tiempoMinimoSRVFUN:{
					required: true,
					number: true
				},
				mesesValAhoSRVFUN:{
					required: true,
					number: true
				},
				saldoMinMesSRVFUN:{
					required: true,
					number: true
				},
				rolAutoApoyoEsc:{
					required: true
				},
				ctaContaApoyoEsc:{
					required: true
				},
				tipoCtaApoyoEscMay: {
					required: true
				},
				tipoCtaApoyoEscMen: {
					required: true
				},
				mesInicioAhoCons:{
					required: true
				},
				montoMinMesApoyoEsc:{
					required: true,
					number: true
				},
				porcentajeCob:{
					number: true,
					maxlength: 10
				},
				coberturaMin:{
					number: true,
					maxlength: 10
				},
				compromisoAho :{
					required: true,
					number: true
				},
				tipoCtaBeneCancel: {
					required: true
				},
				cuentaVista: {
					required: true
				},
				ejecutivoFR: {
					required: true
				},
				versionWS: {
					required: true,
					maxlength: 40
				},
				CCHaberesEx :{
					required: true,
					maxlength: 30
				},
				CCProtecAhorro :{
					required: true,
					maxlength: 30
				},
				CCServifun :{
					required: true,
					maxlength: 30
				},
				CCApoyoEscolar :{
					required: true,
					maxlength: 30
				},
				CCContaPerdida :{
					required: true,
					maxlength: 30
				},
				tipoCtaProtecMen :{
					required: true
				},
				edadMinimaCliMen :{
					required: true,
					number: true,
					maxlength: 6
				},
				edadMaximaCliMen :{
					required: true,
					number: true,
					maxlength: 6
				},
				mesesConsPago:{
					required: true,
					number: true,
					min: 0
				},
				montoMinActCom:{
					required: true,
					number: true
				},
				montoMaxActCom:{
					required: true,
					number: true
				}

			},		
			messages: {
				empresaID: {
					required: 'Especificar la empresa',
					minlength: 'Al menos 1 Caracter',
					number: 'solo números'
				},
				ctaOrdinaria: {
					required: 'Especificar tipo de cuenta'
				},
				tipoCtaProtec: {
					required: 'Especificar tipo de cuenta'
				},
				montoMaxProtec: {
					required: 'Especificar monto máximo',
					number: 'solo números'
				},
				montoPROFUN: {
					required: 'Especificar monto',
					number: 'solo números'
				},
				aporteMaxPROFUN: {
					required: 'Especificar monto máximo',
					number: 'solo números'
				},
				maxAtraPagPROFUN: {
					required: 'Especificar Máximo de Atraso en Meses',
					number: 'solo números'
				},
				haberExSocios:{
					required: 'Especificar número de cuenta'
				},
				ctaProtecCta:{
					required: 'Especificar número de cuenta'
				},
				ctaProtecCre:{
					required: 'Especificar número de cuenta'
				},
				ctaContaPROFUN:{
					required: 'Especificar número de cuenta'
				},
				perfilAutoriSRVFUN:{
					required: 'Especificar perfil'
				},
				ctaContaSRVFUN:{
					required: 'Especificar número de cuenta'
				},
				montoApoyoSRVFUN:{
					required: 'Especificar monto',
					number: 'solo números'
				},
				monApoFamSRVFUN:{
					required: 'Especificar monto',
					number: 'solo números'
				},
				edadMaximaSRVFUN:{
					required: 'Especificar edad',
					number: 'solo números'
				},
				tiempoMinimoSRVFUN:{
					required: 'Especificar tiempo',
					number: 'solo números'
				},
				mesesValAhoSRVFUN:{
					required: 'Especificar meses',
					number: 'solo números'
				},
				saldoMinMesSRVFUN:{
					required: 'Especificar saldo mínimo',
					number: 'solo números'
				},
				rolAutoApoyoEsc:{
					required: 'Especificar perfil'
				},
				ctaContaApoyoEsc:{
					required: 'Especificar número de cuenta'
				},
				tipoCtaApoyoEscMay: {
					required: 'Especificar tipo de cuenta'
				},
				tipoCtaApoyoEscMen: {
					required: 'Especificar tipo de cuenta'
				},
				mesInicioAhoCons:{
					required: 'Especificar mes'
				},
				montoMinMesApoyoEsc:{
					required: 'Especificar monto',
					number: 'Solo números'
				},
				porcentajeCob:{
					number: 'Solo números',
					maxlength: 'Máximo 10 caracteres'
				},
				coberturaMin:{
					number: 'Solo números',
					maxlength: 'Máximo 10 caracteres'
				},
				compromisoAho: {
					required: 'Especificar Compromiso de Ahorro',
					number: 'solo números'
				},
				tipoCtaBeneCancel: {
					required: 'Especificar tipo de cuenta'
				},
				cuentaVista: {
					required: 'Especificar tipo de cuenta'
				},
				ejecutivoFR: {
					required: 'Especificar Ejecutivo FR'
				},
				versionWS: {
					required: 'Especificar Version del Servicio Web',
					maxlength: 'Máximo 40 caracteres'
				},
				CCHaberesEx :{
					required: 'Especificar Nomenclatura',
					maxlength: 'Máximo 30 caracteres'
				},
				CCProtecAhorro :{
					required: 'Especificar Nomenclatura',
					maxlength: 'Máximo 30 caracteres'
				},
				CCServifun :{
					required: 'Especificar Nomenclatura',
					maxlength: 'Máximo 30 caracteres'
				},
				CCApoyoEscolar :{
					required: 'Especificar Nomenclatura',
					maxlength: 'Máximo 30 caracteres'
				},
				CCContaPerdida :{
					required: 'Especificar Nomenclatura',
					maxlength: 'Máximo 30 caracteres'
				},
				tipoCtaProtecMen :{
					required:  'Especificar tipo de cuenta'
				},
				edadMinimaCliMen :{
					required: 'Especificar Edad Mínima',
					number: 'Solo números',
					maxlength: 'Máximo 6 caracteres'
				},
				edadMaximaCliMen :{
					required: 'Especificar Edad Máxima',
					number: 'Solo números',
					maxlength: 'Máximo 6 caracteres'
				},
				mesesConsPago: {
					required: 'Especificar Meses Constantes de Pago',
					number: 'Solo números',
					min: 'Especificar número Mayor o Igual a Cero'
				},
				montoMinActCom:{
					required: 'Especificar monto',
					number: 'Solo números'
				},
				montoMaxActCom:{
					required: 'Especificar monto',
					number: 'Solo números'
				}
			}		
		});
			
		/*=========== VALIDA FORMA GENERICA1 ================ */
$('#formaGenerica1').validate({			
			rules: {	
				promedioMinimo: {
					required: function() {return $('#apoyoEscCicloID').val() != 0;},
					min: 0,
					number: true,
					max: 100
				},		
				cantidad: {
					required: function() {return $('#apoyoEscCicloID').val() != 0;},
					number: true,
					maxlength:16
				},	
				mesesAhorroCons: {
					required: function() {return $('#apoyoEscCicloID').val() != 0;},
					number: true,
					min: 0,
					max:9000

				},
				tipoCalculo: {
					required:	function() {return $('#apoyoEscCicloID').val() != 0;},
				},
				apoyoEscCicloID: {
					required: function() {return $('#promedioMinimo').val() != '';}
				}
				
			},
			messages: {
				promedioMinimo: {
					required: 'Especificar promedio mínimo',
					number: 'Sólo números',
					min: 'Mayor a cero',
					max: 'Menor o igual a 100'					
					},
				cantidad: {
					required: 'Especificar cantidad',
					number: 'Sólo números',
					maxlength: 'Máximo 16 caracteres'					
				},	
				mesesAhorroCons: {
					required: 'Especificar meses de ahorro constante',
					number: 'Sólo números',
					min: 'Mayor o igual a cero',
					max: 'Especifique un número menor'
				},
				tipoCalculo: {
					required:'Especificar tipo de cálculo'
				},
				apoyoEscCicloID: {
					required: 'Especificar grado escolar'
				}
			}		
		});

/*=========== VALIDA FORMA GENERICA2 ================ */
$('#formaGenerica2').validate({			
			rules: {	
				usuarioID: {
					required:true,
					number: true
				}						
			},
			messages: {
				usuarioID: {
					required: 'Especificar usuario',
					number: 'Sólo números'					
					}				
			}		
		});

		
/* =================== FUNCIONES ========================= */
	
	/*consulta los datos de la empresa, si la escuentra presenta los datos en la vista */
	function validaEmpresaID(control) {
		var numEmpresaID = $('#empresaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoCon = 1;
		var ParametrosCajaBean = {
				'empresaID'	:numEmpresaID
		};
		if (numEmpresaID != '' && !isNaN(numEmpresaID)) {
			if (numEmpresaID == '0') {			
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('btnGrabarAsambleas','submit');
				inicializaForma('formaGenerica', 'empresaID');
				$('#tipoCtaProtec').val("0").selected = true;
			} else {								
							
				parametrosCajaServicio.consulta(tipoCon,ParametrosCajaBean,function(parametrosCajaBean) {
					if (parametrosCajaBean != null) {
						habilitaBoton('modificar', 'submit');	
						habilitaBoton('agrega', 'submit');
						habilitaBoton('btnagregar','submit');
						habilitaBoton('btnGrabarAsambleas','submit');
						dwr.util.setValues(parametrosCajaBean);	
						if(parametrosCajaBean.permiteAdicional == 'S'){
							$('#permiteAdicional').attr('checked',true);
						}
						else{
							$('#permiteAdicional1').attr('checked',true);
						}
						if(parametrosCajaBean.validaCredAtras == 'S'){
							$('#validaCredAtras').attr('checked',true);
						}
						else{
							$('#validaCredAtras1').attr('checked',true);
						}
						if(parametrosCajaBean.validaGaranLiq == 'S'){
							$('#validaGaranLiq').attr('checked',true);
						}
						else{
							$('#validaGaranLiq1').attr('checked',true);
						}
						
						$('#tipoProdCap').val(parametrosCajaBean.tipoProdCap).selected = true;
						// selecciona las opciones del combo de gastos pasivos
						consultaComboGastosPasivos(parametrosCajaBean.gastosPasivos);
						consultaCuenta('tipoCuenta');
						consultaRoles('perfilAutoriSRVFUN','perfilAutoriSRVFUNDes');
						consultaRoles('perfilCancelPROFUN','perfilCancelPROFUNDes');
						consultaRoles('rolAutoApoyoEsc','rolAutoApoyoEscDes');
						consultaRoles('perfilAutoriProtec','perfilAutoriProtecDes');
						consultaRoles('ejecutivoFR','ejecutivoFRDes');
						consultaRoles('rolCancelaCheque','desRolCancelaCheque');
						maestroCuentasDescripcion('haberExSocios','haberExSociosDes');
						maestroCuentasDescripcion('ctaProtecCta','ctaProtecCtaDes');
						maestroCuentasDescripcion('ctaProtecCre','ctaProtecCreDes');
						maestroCuentasDescripcion('ctaContaPROFUN','ctaContaPROFUNDes');
						maestroCuentasDescripcion('ctaContaSRVFUN','ctaContaSRVFUNDes');
						maestroCuentasDescripcion('ctaContaApoyoEsc','ctaContaApoyoEscDes');
						maestroCuentasDescripcion('ctaContaPerdida','ctaContaPerdidaDes');
						mostrarGridApoyoEscolar();
						consultaGatosSocioe();
						consultaUsuarioAutorizados();
						
					}
					else {
						limpiaForm($('#formaGenerica'));						
						deshabilitaBoton('modificar','submit');	
						deshabilitaBoton('btnGrabarAsambleas','submit');
						$('#empresaID').focus();
						$('#empresaID').select();
						$('#ctaOrdinaria').val("0").selected = true;
						$('#tipoCtaProtec').val("0").selected = true;
						$('#tipoCtaProtecMen').val("0").selected = true;
						$('#tipoCtaApoyoEscMay').val("0").selected = true;
						$('#tipoCtaApoyoEscMen').val("0").selected = true;
						$('#tipoCtaBeneCancel').val("0").selected = true;
						$('#cuentaVista').val("0").selected = true;
					mostrarGridApoyoEscolar();
					consultaUsuarioAutorizados();
					}
				});
			}//else
		}//if
		 else {
				limpiaForm($('#formaGenerica'));						
				deshabilitaBoton('modificar','submit');
				deshabilitaBoton('btnGrabarAsambleas','submit');					
				$('#empresaID').focus();
				$('#empresaID').select();
				$('#ctaOrdinaria').val("0").selected = true;
				$('#tipoCtaProtec').val("0").selected = true;
				$('#tipoCtaProtecMen').val("0").selected = true;
				$('#tipoCtaApoyoEscMay').val("0").selected = true;
				$('#tipoCtaApoyoEscMen').val("0").selected = true;
				$('#tipoCtaBeneCancel').val("0").selected = true;
				$('#cuentaVista').val("0").selected = true;
				mostrarGridApoyoEscolar();
				consultaUsuarioAutorizados();
			}
	}//validaEmpresaID
	
	
	/*selecciona en el combo el tipo que tenga registrada la empresa*/
	function consultaCuenta(idControl) {
		var jqCuenta = eval("'#" + idControl + "'");
		var numCta = $(jqCuenta).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var TipoCuentaBeanCon = {
				'tipoCuentaID':numCta	};								
		if(numCta != '' && !isNaN(numCta)){												
			tiposCuentaServicio.consulta(catTipoConsultaTipoCuenta.foranea, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){									
					$('#descripcion').val(tipoCuenta.descripcion);																
				}else{
					alert("No existe la cuenta"); 
					$('#tipoCuenta').val('');	
					$('#tipoCuenta').focus();	
					$('#descripcion').val("");					
				}     						
		});
		}
	}
			  			
    /*consulta los tipos de cuentas y las agrega al combo */
		function consultaTiposCuenta() {	
					var bean={};
					dwr.util.removeAllOptions('ctaOrdinaria'); 
					dwr.util.addOptions('ctaOrdinaria', {'':'SELECCIONAR'}); 
					tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
						dwr.util.addOptions('ctaOrdinaria', tiposCuenta, 'tipoCuentaID', 'descripcion');
					});
					dwr.util.removeAllOptions('tipoCtaProtec'); 
					dwr.util.addOptions('tipoCtaProtec', {'':'SELECCIONAR'}); 
					tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
						dwr.util.addOptions('tipoCtaProtec', tiposCuenta, 'tipoCuentaID', 'descripcion');
					});
					dwr.util.removeAllOptions('tipoCtaProtecMen'); 
					dwr.util.addOptions('tipoCtaProtecMen', {'':'SELECCIONAR'}); 
					tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
						dwr.util.addOptions('tipoCtaProtecMen', tiposCuenta, 'tipoCuentaID', 'descripcion');
					});
					
					dwr.util.removeAllOptions('tipoCtaApoyoEscMay'); 
					dwr.util.addOptions('tipoCtaApoyoEscMay', {'':'SELECCIONAR'}); 
					tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
						dwr.util.addOptions('tipoCtaApoyoEscMay', tiposCuenta, 'tipoCuentaID', 'descripcion');
					});
					
					dwr.util.removeAllOptions('tipoCtaApoyoEscMen'); 
					dwr.util.addOptions('tipoCtaApoyoEscMen', {'':'SELECCIONAR'}); 
					tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
						dwr.util.addOptions('tipoCtaApoyoEscMen', tiposCuenta, 'tipoCuentaID', 'descripcion');
					});
					
					dwr.util.removeAllOptions('tipoCtaBeneCancel'); 
					dwr.util.addOptions('tipoCtaBeneCancel', {'':'SELECCIONAR'}); 
					tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
						dwr.util.addOptions('tipoCtaBeneCancel', tiposCuenta, 'tipoCuentaID', 'descripcion');
					});
					
					dwr.util.removeAllOptions('cuentaVista'); 
					dwr.util.addOptions('cuentaVista', {'':'SELECCIONAR'}); 
					tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
						dwr.util.addOptions('cuentaVista', tiposCuenta, 'tipoCuentaID', 'descripcion');
					});
			}


	/* Consulta los tipos de apoyo escolar por ciclo */
		function consultaTiposApoyo(){
			var bean={
				'apoyoEscCicloID' :0,
				'descripcion'	:''
			};


			dwr.util.removeAllOptions('apoyoEscCicloID'); 
			dwr.util.addOptions('apoyoEscCicloID', {'':'SELECCIONAR'}); 
			apoyoEscCicloServicio.listaCombo(1,bean, function(tiposApoyo){
				dwr.util.addOptions('apoyoEscCicloID', tiposApoyo, 'apoyoEscCicloID', 'descripcion');
			});
		}
		
		
		/* consulta el no. de cuenta y agrega su descripcion al campo correspondiente */
		function maestroCuentasDescripcion(idControl,campoDescripcion,otraCuentaContable){ 		
			var jqCtaContable = eval("'#" + idControl + "'");
			var numCtaContable =  $(jqCtaContable).val(); 
			var conForanea = 2;
			var CtaContableBeanCon = {
					'cuentaCompleta':numCtaContable
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCtaContable != '' && !isNaN(numCtaContable) ){
				cuentasContablesServicio.consulta(conForanea,CtaContableBeanCon,function(ctaConta){
					if(ctaConta!=null){
						
						if(ctaConta.grupo != "E"){
							$('#'+campoDescripcion).val(ctaConta.descripcion);	
						} 
						else{
							alert("Sólo Cuentas Contables De Detalle");
							$(jqCtaContable).val("");
							$('#'+campoDescripcion).val('');
							$(jqCtaContable).focus();		
						}
					}
					else{
						alert("No existe la cuenta contable");
                        $(jqCtaContable).val(''); 
						$('#'+campoDescripcion).val('');
						$(jqCtaContable).focus();
					}
				}); 
			}
			else {
			/*	$(jqCtaContable).val("");
				$('#'+campoDescripcion).val('');*/
			}		
		}	
		
		
		/* consulta un rol */
		function consultaRoles(idControl,descripcion) { 
			var jqRol = eval("'#" + idControl + "'");
			var jqRolDes = eval("'#"+descripcion+"'");
			var numRol = $(jqRol).val();	 
			var conRol=2;
			var rolesBeanCon = {
	  				'rolID':numRol
					};	
			setTimeout("$('#cajaLista').hide();", 200);		 
			if(numRol != '' && !isNaN(numRol)){ 
				rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) { 
					if(roles!=null){	
						$(jqRolDes).val(roles.nombreRol);	
					}else{
						alert("No Existe el Rol"); 
						$(jqRol).val('');	
						$(jqRolDes).val("");
						$(jqRol).focus();
					}    						
				});
			}
			else {
				$(jqRolDes).val("");
			}
		}
		
		$("#edadMinimaCliMen").blur(function (){
			if( this.value != ''){
				var edadMinima = $("#edadMinimaCliMen").asNumber();
				var edadMaxima = $("#edadMaximaCliMen").asNumber();
				$('#edadMinimaCliMen').formatCurrency({
					colorize: true,
					positiveFormat: '%n', 
					negativeFormat: '%n',
					roundToDecimalPlace: 0

				});
				
					if(edadMaxima > 0 && edadMinima > edadMaxima){
						alert("La Edad Mínima es Incorrecta");
						this.focus();
						this.select();
					}
			}
		});
		
		$("#edadMaximaCliMen").blur(function (){
			if(this.value != ''){
				var edadMinima = $("#edadMinimaCliMen").asNumber();
				var edadMaxima = $("#edadMaximaCliMen").asNumber();
				$('#edadMaximaCliMen').formatCurrency({
					colorize: true,
					positiveFormat: '%n', 
					negativeFormat: '%n',
					roundToDecimalPlace: 0

				});
				
					if(edadMinima > 0 && edadMaxima < edadMinima){
						alert("La Edad Máxima es Incorrecta");
						this.focus();
						this.select();
					}
			}
		});


		$("#mesesConsPago").blur(function (){
			if( this.value != ''){
				$('#mesesConsPago').formatCurrency({
					colorize: true,
					positiveFormat: '%n', 
					negativeFormat: '%n',
					roundToDecimalPlace: 0

				});
			}
		});
		
		
		$("#montoMinActCom").blur(function (){
			
				if ($('#montoMinActCom').asNumber() > $('#montoMaxActCom').asNumber()){
					alert("El Monto Mínimo no debe ser Mayor al Máximo");					
					$('#montoMinActCom').val(0);
					$('#montoMinActCom').focus();
					$('#montoMinActCom').select();
					event.preventDefault();	  			
				
			}
		});
		

		$("#montoMaxActCom").blur(function (){
			
				if ($('#montoMinActCom').asNumber() > $('#montoMaxActCom').asNumber()){
					alert("El Monto Mínimo no debe ser Mayor al Máximo");
					$('#montoMaxActCom').val($('#montoMinActCom').val());
					$('#montoMaxActCom').focus();
					$('#montoMaxActCom').select();
					event.preventDefault();	  			
				
			}
		});
		
	});  /* =============0  FIN DE JQUERY    0================= */


	// funcion para consultar los detalles de parametros apoyo escolar */
	function mostrarGridApoyoEscolar(){
			 var empresa = document.getElementById('empresaID').value;
		if (empresa != ''  && !isNaN(empresa)){ 
			var params = {};
			params['tipoLista'] = 1;
			
			        
			$.post("gridApoyoEscolarParametros.htm", params, function(paramApoyoEscolarBean){
				   
				if(paramApoyoEscolarBean.length >0) {
					agregaFormatoControles('formaGenerica1');
					$('#gridApoyoEscolarDiv').html(paramApoyoEscolarBean);
					$('#gridApoyoEscolarDiv').show();	
					habilitaBoton('agrega', 'submit');
					}else{
					$('#gridApoyoEscolarDiv').html("");
					$('#gridApoyoEscolarDiv').hide();
					deshabilitaBoton('agrega', 'submit');
				}
			});
	}
	else{
		$('#gridApoyoEscolarDiv').html("");
		$('#gridApoyoEscolarDiv').hide();
		deshabilitaBoton('agrega', 'submit');
	}
}

	function eliminar(paramApoyoEsc){		
		document.getElementById('tipoTransaccionGrid').value = 3;
		document.getElementById('tipoTransaccion').value = 0;
	    document.getElementById('paramApoyoEscID').value = paramApoyoEsc;   
	   
	    var tipoTransaccionGrid = 3;
		var paramBean = {
			'paramApoyoEscID'	:paramApoyoEsc
		};
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
		$('#contenedorForma').block({
				message: $('#mensaje'),
			 	css: {border:		'none',
			 			background:	'none'}
		});
		paramApoyoEscolarServicio.grabaTransaccion(tipoTransaccionGrid, paramBean, function(mensajeTransaccion) {
			if(mensajeTransaccion!=null){
				alert(mensajeTransaccion.descripcion);
				$('#contenedorForma').unblock(); 
				funcionExitoGridApoyoEsc();
				document.getElementById("empresaID").focus();			
			}else{				
				alert("Ocurrio un Error al eliminar el grado escolar");			
			}
		});
	}


	function consultaUsuarioAutorizados(){	
		var empresa = document.getElementById('empresaID').value;
		if (empresa != ''  && !isNaN(empresa)){ 
		var params = {};
		params['tipoLista'] = 1;
		
		$.post("asamGralUsuarioAutGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divPersonalAutorizado').html(data);
				$('#divPersonalAutorizado').show();
				habilitaBoton('btnagregar','submit');
			}else{	
			
				$('#divPersonalAutorizado').html("");
				$('#divPersonalAutorizado').hide();
				deshabilitaBoton('btnagregar','submit');
				
				}
			});
		}
		else{
			$('#divPersonalAutorizado').html("");
			$('#divPersonalAutorizado').hide();
			deshabilitaBoton('btnagregar','submit');
		}
		}
	
	function agregarPersonalAut(){	
		var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglonn' + nuevaFila + '" name="renglonn">';
		  
		if(numeroFila == 0){
			tds += '<input id="consecutivoID'+nuevaFila+'" name="consecutivoID" value="1" type="hidden"/>';
			tds += '<input type="hidden" id="asamGralID'+nuevaFila+'" name="lasamGralID" />';								
			tds += '<td><input type="text" id="usuarioID'+nuevaFila+'" name="lusuarioID" size="6" onkeypress="listaUsuario(this.id)" onblur="consultaUsuario(this.id)" /></td>';
			tds += '<td><input type="text"  id="nombreCompleto'+nuevaFila+'" name="lnombreCompleto" size="40" readOnly="true"/></td>';
			tds += '<td><input type="text"  id="nombreRol'+nuevaFila+'" name="lnombreRol" size="40" readOnly="true"/></td>';
			tds += '<td><input type="hidden" id="rolID'+nuevaFila+'" name="lrolID"/></td>';
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<input type="hidden"  id="consecutivoID'+nuevaFila+'" name="consecutivoID" value=value="'+valor+'" />';
			tds += '<input type="hidden" id="asamGralID'+nuevaFila+'" name="lasamGralID" />';								
			tds += '<td><input type="text" id="usuarioID'+nuevaFila+'" name="lusuarioID" size="6" onkeypress="listaUsuario(this.id)" onblur="consultaUsuario(this.id)" /></td>';
			tds += '<td><input type="text"  id="nombreCompleto'+nuevaFila+'" name="lnombreCompleto" size="40"  readOnly="true"/></td>';
			tds += '<td><input type="text"  id="nombreRol'+nuevaFila+'" name="lnombreRol" size="40" readOnly="true"/></td>';
			tds += '<td><input type="hidden" id="rolID'+nuevaFila+'" name="lrolID"/></td>';
		}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarPersonalAut(this.id)"/>';
			tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarPersonalAut()"/></td>';
			tds += '</tr>';	   	   
			$("#miTabla").append(tds);
			return false;	
		}
		function consultaFilas(){
			var totales=0;
			$('tr[name=renglonn]').each(function() {
				totales++;		
			});
			return totales;
		}
	
		// Función para eliminar Filas en el grid de Porcentajes	
		function eliminarPersonalAut(control){
			var contador = 0 ;
			var numeroID = control;
			
			var jqRenglon = eval("'#renglonn" + numeroID + "'");
			var jqNumero = eval("'#consecutivoID" + numeroID + "'");
			var jqAsamGral = eval("'#asamGralID" + numeroID + "'");		
			var jqUsuarioID = eval("'#usuarioID" + numeroID + "'");
			var jqNombreCompleto =eval("'#nombreCompleto" + numeroID + "'");
			var jqNombreRol=eval("'#nombreRol" + numeroID + "'");
			var jqRolID=eval("'#rolID" + numeroID + "'");
			var jqAgregar=eval("'#agrega" + numeroID + "'");
			var jqEliminar = eval("'#" + numeroID + "'");
		
			// se elimina la fila seleccionada
			$(jqRenglon).remove();
			$(jqNumero).remove();
			$(jqAsamGral).remove();
			$(jqUsuarioID).remove();
			$(jqNombreCompleto).remove();
			$(jqNombreRol).remove();
			$(jqRolID).remove();
			$(jqAgregar).remove();
			$(jqEliminar).remove();
		
			//Reordenamiento de Controles
			contador = 1;
			var numero= 0;
			$('tr[name=renglonn]').each(function() {	
				numero= this.id.substr(8,this.id.length);
				var jqRenglon1 = eval("'#renglonn"+numero+"'");
				var jqNumero1 = eval("'#consecutivoID"+numero+"'");
				var jqAsamGral1 = eval("'#asamGralID"+numero+"'");		
				var jqUsuarioID1= eval("'#usuarioID"+numero+"'");
				var jqNombreCompleto1=eval("'#nombreCompleto"+ numero+"'");
				var jqNombreRol1=eval("'#nombreRol"+ numero+"'");
				var jqRolID1=eval("'#rolID"+ numero+"'");
				var jqAgregar1=eval("'#agrega"+ numero+"'");
				var jqEliminar1 = eval("'#"+numero+ "'");

				$(jqNumero1).attr('id','consecutivoID'+contador);
				$(jqAsamGral1).attr('id','asamGralID'+contador);
				$(jqUsuarioID1).attr('id','usuarioID'+contador);
				$(jqNombreCompleto1).attr('id','nombreCompleto'+contador);
				$(jqNombreRol1).attr('id','nombreRol'+contador);
				$(jqRolID1).attr('id','rolID'+contador);
				$(jqAgregar1).attr('id','agrega'+contador);
				$(jqEliminar1).attr('id',contador);
				$(jqRenglon1).attr('id','renglonn'+ contador);
				contador = parseInt(contador + 1);	
				
			});
			
		}
	
		// Función para listar los usuarios.
		function listaUsuario(idControl){
			var jq = eval("'#" + idControl + "'");
			$(jq).bind('keyup',function(e){
				var jqControl = eval("'#" + this.id + "'");
				var num = $(jqControl).val();
					
				var camposLista = new Array();
				var usuariosLista = new Array();			
				camposLista[0] = "nombreCompleto"; 
				usuariosLista[0] = num;
				lista(idControl, '1', '14', camposLista, usuariosLista, 'listaUsuarios.htm');
			});
		}

		var asamGralUsuarioAut = {
		  		'consultaUsuAsamGral'	: 14
			};	
		// Función Para consultar los usuarios.
		function consultaUsuario(control) {
				var TipoConsulta = 14;
				var jq = eval("'#" + control + "'");
				var numUsuario = $(jq).val();	
				var jqNombreCom = eval("'#nombreCompleto" + control.substr(9) + "'");
				var jqNombreRol = eval("'#nombreRol" + control.substr(9) + "'");
				var jqRolID = eval("'#rolID" + control.substr(9) + "'");
				setTimeout("$('#cajaLista').hide();", 200);	
				if(numUsuario != '' && !isNaN(numUsuario)){
					var usuariosCon = {
						'usuarioID':numUsuario	
					};
					if(verificaSeleccionado(control) == 0){
					usuarioServicio.consulta(TipoConsulta,usuariosCon,function(usuario) {
							if(usuario!=null){
								$(jqNombreCom).val(usuario.nombreCompleto);
								$(jqNombreRol).val(usuario.nombreRol);
								$(jqRolID).val(usuario.rolID);

							}else{
								alert("El usuario No Existe");
								$(jq).val("");
								$(jqNombreCom).val("");
								$(jqNombreRol).val("");
								$(jqRolID).val("");
								$(jq).focus();
							}
						});
					}
				}else{
					$(jq).val("");
					$(jqNombreCom).val("");
					$(jqNombreRol).val("");
					$(jqRolID).val("");
				}
		}
		
		
		function verificaSeleccionado(idCampo){
			var contador = 0;
			var nuevoUsuario=$('#'+idCampo).val();
			var numeroNuevo= idCampo.substr(9,idCampo.length);
			var jqNombreCom	= eval("'nombreCompleto" + numeroNuevo+ "'");
			var jqNombreRol	= eval("'nombreRol" + numeroNuevo+ "'");
			$('tr[name=renglonn]').each(function() {
				var numero= this.id.substr(8,this.id.length);
				var jqIdUsuario = eval("'usuarioID" + numero+ "'");
				var valorUsuarios = $('#'+jqIdUsuario).val();
				if(jqIdUsuario != idCampo){
					if(valorUsuarios == nuevoUsuario){
						alert("El usuario ya Existe");
						$('#'+idCampo).focus();
						$('#'+idCampo).val("");
						$('#'+jqNombreCom).val("");
						$('#'+jqNombreRol).val("");
						contador = contador+1;
					}
				}
			});
			return contador;
		}

		function guardarUsuarios(){
			var mandar = verificarvacios();	
			if(mandar!=1){
				var numCodigo = $('input[name=consecutivoID]').length;
				$('#datosGrid').val("");
				for(var i = 1; i <= numCodigo; i++){
					if(i == 1){
						$('#datosGrid').val($('#datosGrid').val() +
								document.getElementById("usuarioID"+i+"").value);
					}else{
						$('#datosGrid').val($('#datosGrid').val() + '[' +
								document.getElementById("usuarioID"+i+"").value);
					}
				}
			}
			else{
				alert("Especifique el Número de Usuario");
				event.preventDefault();
			}
		}

		function verificarvacios(){
			quitaFormatoControles('datosGrid');
			var numCodig = $('input[name=consecutivoID]').length;
			
			$('#divPersonalAutorizado').val("");
			for(var i = 1; i <= numCodig; i++){
				var idsu = document.getElementById("usuarioID"+i+"").value;
					if (idsu ==""){
						document.getElementById("usuarioID"+i+"").focus();
					$(idsu).addClass("error");
						return 1; 
					}
			}
		}
		


/*funcion que se ejecuta cuando la operacion fue un exito */
function funcionExitoParamCaja(){
	inicializaForma('formaGenerica','empresaID');
	inicializaForma('formaGenerica2','empresaID');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('btnagregar','submit');
	deshabilitaBoton('btnGrabarAsambleas','submit');
	$('#ctaOrdinaria').val("0").selected = true;
	$('#tipoCtaProtec').val("0").selected = true;
	$('#tipoCtaProtecMen').val("0").selected = true;
	$('#tipoCtaApoyoEscMay').val("0").selected = true;
	$('#tipoCtaApoyoEscMen').val("0").selected = true;
	$('#tipoCtaBeneCancel').val("0").selected = true;
	$('#cuentaVista').val("0").selected = true;
	$('#tipoProdCap').val("0").selected = true;
	$('#gridApoyoEscolarDiv').hide();	
	$('#divPersonalAutorizado').hide();
	$('#empresaID').focus();
	
}

/*funcion que se ejecuta cuando la operacion fue un fallo */
function funcionFalloParamCaja(){
	
}
			

/*funcion que se ejecuta cuando la operacion fue un exito */
function funcionExitoGridApoyoEsc(){
	inicializaForma('formaGenerica','empresaID');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('btnGrabarAsambleas','submit');
	$('#apoyoEscCicloID').val("0").selected = true;
	$('#tipoCalculo').val("0").selected = true;
	$('#gridApoyoEscolarDiv').hide();	
}

/*funcion que se ejecuta cuando la operacion fue un fallo */
function funcionFalloGridApoyoEsc(){
	
}
			


function ayudaCR(){	
	var data;
	
				       
data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
			'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
					'</tr>'+
					'<tr>'+
						'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal Cliente</b></td>'+
					'</tr>'+ 
			'</table>'+
			'<br>'+
	 '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+  
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplos: </legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 1: </b></td>'+ 
						'<td id="contenidoAyuda">&SO</td>'+
				'</tr>'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 2:</b></td>'+ 
						'<td id="contenidoAyuda">&SC</td>'+
				'</tr>'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+ 
						'<td id="contenidoAyuda">15</td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+  
		'</fieldset>'+
	 '</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}


consultaEgresos();
function consultaEgresos(){
	var tipoCon=5;
	var beanClidatSocioe	={
			
	}
	dwr.util.removeAllOptions('gastosPasivos');

	clidatsocioeServicio.listaCombo(beanClidatSocioe,tipoCon, function(clidatSocioE){
		dwr.util.addOptions('gastosPasivos', clidatSocioE, 'catSocioEID', 'descripcion');
	});
}



function consultaComboGastosPasivos(frecuencia) {
	if(frecuencia){
		var frec= frecuencia.split(',');
		var tamanio = frec.length;
						
		for (var i=0;i< tamanio;i++) {
			var fre = frec[i];
					var jqFrecuencia = eval("'#gastosPasivos option[value="+fre+"]'");  
					$(jqFrecuencia).attr("selected","selected");
			}
	}
}
//devuelve la descripcion de los gastos de ingresos
function consultaGatosSocioe(controlID){	
	var tipoConsulta	=1;
	var catDatSocioE = {
		'catSocioEID'	:  $('#idGastoAlimenta').val()
	};	
	if( $('#idGastoAlimenta').val() >0){
		catDatSocioEServicio.consulta(tipoConsulta,catDatSocioE ,function(catDatSocioE){ 
			if(catDatSocioE!=null){					

				$('#desGastosAlimentacion').val(catDatSocioE.descripcion);
			if(catDatSocioE.tipo == 'I'){
				alert("El Gasto Indicado no es un Egreso");
				$('#idGastoAlimenta').focus();
				$('#idGastoAlimenta').val('');
				$('#desGastosAlimentacion').val('');
			}

			}else{
				alert("El Gasto Indicado no Existe");
				$('#idGastoAlimenta').focus();
				$('#idGastoAlimenta').val('');
				$('#desGastosAlimentacion').val('');
			}
		});
	}

}

function exitoAsambleas(){
	
}