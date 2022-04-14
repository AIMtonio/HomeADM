$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	$('#clienteID').focus();

	var parametroBean = consultaParametrosSession();   

	var catTipoLisAnaliticoAhorro  = {
			'analiticoAhorroExcel'	: 1
	};	

	var catTipoRepAnaliticoAhorro = { 
			'PDF'		: 1,
			'Excel'		: 2
	};	
		
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	consultaMoneda(); 
	consultaTiposCuenta();
	$('#clienteID').val('0');
	$('#nombreCliente').val('TODOS');

	$('#promotorID').val('0');
	$('#nombrePromotorI').val('TODOS');
	$('#estadoID').val('0');
	$('#nombreEstado').val('TODOS');
	$('#municipioID').val('0');
	$('#nombreMuni').val('TODOS');
	
	
	$('#clienteID').bind('keyup',function(e){	
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	
	$('#pdf').attr("checked",true) ; 



	$(':text').focus(function() {	
		esTab = false;
	});

	$('#promotorID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('promotorID', '1', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');
	});	

	$('#clienteID').blur(function() {
		if($('#clienteID').val() > 0) {
			$('#cuentasAho').val("");
			consultaCliente(this.id);
			consultaSucursal();
			consultaTiposCuenta();
		} else{
			setTimeout("$('#cajaLista').hide();", 200);		
			habilita();
			$('#clienteID').val('0');
			$('#nombreCliente').val('TODOS');
			inicializaTodo();
			consultaSucursal();
			consultaTiposCuenta();
		}
	});
		
	$('#cuentasAho').blur(function(){
		consultaCtaAho();
	});
	$('#sucursal').change(function(){
		$('#cuentasAho').val("");
	});
	$('#tipoCuentaID').change(function(){
		$('#cuentasAho').val("");
	});
	
	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});

	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";


		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();

		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});

	$('#excel').click(function() {
		if($('#excel').is(':checked')){	
			$('#tdPresenacion').hide('slow');
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});
	

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});

	$('#generar').click(function() { 

		if($('#pdf').is(":checked") ){
			generaPDF();
		}

		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});
	
	 $('#cuentasAho').bind('keyup',function(e){
		    var camposLista = new Array();
			var parametrosLista = new Array();
			 camposLista[0] = "clienteID";
			 camposLista[1]="tipoCuentaID";
			 camposLista[2]="institucionID";
			 camposLista[3]="cuentaAhoID";
			parametrosLista[0] = $('#clienteID').val();
			parametrosLista[1]=$("#tipoCuentaID option:selected").val();
			parametrosLista[2]=$("#sucursal option:selected").val();
			parametrosLista[3]=$('#cuentasAho').val();
			listaAlfanumerica('cuentasAho', '2', '19', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');	

		 
	});
	 
	 
	 
	 
	//------------ Validaciones de Controles -------------------------------------


	function consultaCliente(idControl) {
		inicializaTodo();
		var jqCliente  = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();	
		var conCliente =1;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(varclienteID != '' && !isNaN(varclienteID)){
			clienteServicio.consulta(conCliente,varclienteID,function(cliente){
						if(cliente!=null){	
							var tipo = (cliente.tipoPersona);
								if(tipo=="F"){
									$('#nombreCliente').val(cliente.nombreCompleto);
								}
								if(tipo=="M"){
									$('#nombreCliente').val(cliente.razonSocial);
								}		
								if(tipo=="A"){
									$('#nombreCliente').val(cliente.nombreCompleto);
								}		
								$('#promotorID').val(cliente.promotorActual);
								consultaPromotorI('promotorID');
								$('#sexo').val(cliente.sexo);
								validaDirCliente();
								deshabilita();							
						}else{
							mensajeSis("No Existe el Cliente");
							$(jqCliente).focus();
							$(jqCliente).select();
							$('#nombreCliente').val("");
							$(jqCliente).val("");
						
						}    						
				});
			}
	}	



	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********

	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $(jqPromotor).val();	
		var tipConForanea = 2;	
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);
			$('#nombrePromotorI').val('TODOS');
		}
		else	

			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotorI').val(promotor.nombrePromotor); 

					}else{
						mensajeSis("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}    	 						
				});
			}
	}


	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numEstado == '' || numEstado==0){
			$('#estadoID').val(0);
			$('#nombreEstado').val('TODOS');

			var municipio= $('#municipioID').val();
			if(municipio != '' && municipio!=0){
				$('#municipioID').val('');
				$('#nombreMuni').val('TODOS');
			}
		}
		else	
			if(numEstado != '' && !isNaN(numEstado) ){
				estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
					if(estado!=null){							
						$('#nombreEstado').val(estado.nombre);

						var municipio= $('#municipioID').val();
						if(municipio != '' && municipio!=0){
							consultaMunicipio('municipioID');
						}

					}else{
						mensajeSis("No Existe el Estado");
						$('#estadoID').val(0);
						$('#nombreEstado').val('TODOS');
					}    	 						
				});
			}
	}	



	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numMunicipio == '' || numMunicipio==0 || numEstado == '' || numEstado==0){

			if(numEstado == '' || numEstado==0 && numMunicipio!=0){
				mensajeSis("No ha selecionado ningún estado.");
				$('#estadoID').focus();
			}
			$('#municipioID').val(0);
			$('#nombreMuni').val('TODOS');
		}
		else	
			if(numMunicipio != '' && !isNaN(numMunicipio)){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){							
						$('#nombreMuni').val(municipio.nombre);

					}else{
						mensajeSis("No Existe el Municipio");
						$('#municipioID').val(0);
						$('#nombreMuni').val('TODOS');
					}    	 						
				});
			}
	}	

	// fin validacion Promotor, Estado, Municipio



	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
	//	dwr.util.addOptions( 'sucursal', {'0':'Todas'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
			$('#sucursal').val(parametroBean.sucursal);
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});



	function consultaMoneda() {		
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function consultaTiposCuenta() {			
  		dwr.util.removeAllOptions('tipoCuentaID'); 
		dwr.util.addOptions('tipoCuentaID', {0:'TODAS'}); 
		tiposCuentaServicio.listaCombo(6, function(tiposCuenta){
		dwr.util.addOptions('tipoCuentaID', tiposCuenta, 'tipoCuentaID', 'descripcion');
		});
	}

	


	function generaExcel() {
		
		$('#pdf').attr("checked",false) ;
		
		if($('#excel').is(':checked')){	
			var tr= catTipoRepAnaliticoAhorro.Excel; 
			var tl= catTipoLisAnaliticoAhorro .analiticoAhorroExcel;  
			var clienteID = $("#clienteID").val();
			var cuentasAho = $("#cuentasAho").val();
			var sucursal = $("#sucursal option:selected").val();
			var monedaID = $("#monedaID option:selected").val();
			
		
			var tipoCuentaID=$("#tipoCuentaID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $("#promotorID").val();
			var genero =$("#sexo option:selected").val();
			//$("#indentiClienteServicio option:selected").html(),
			var estadoID=$("#estadoID").val();
			var municipioID=$("#municipioID").val();
			var fechaEmision = parametroBean.fechaSucursal;
			
			/// VALORES TEXTO
			var nombreCliente = $("#nombreCliente ").val();
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreTipocuenta=$("#tipoCuentaID option:selected").val();
			var nombreCuentaAho=$("#cuentasAho").val();
			var nombreUsuario = parametroBean.claveUsuario; 
			var nombrePromotorI = $("#nombrePromotorI").val();
			var nombreGenero =$("#sexo option:selected").val();
			var nombreEstado=$("#nombreEstado").val();
			var nombreMunicipio=$("#nombreMuni").val();	
			var nombreInstitucion =  parametroBean.nombreInstitucion; 


			if(nombreCuentaAho=='0'){
				nombreCuentaAho='TODAS';
			}

			if(nombreCuentaAho==''){
				nombreCuentaAho='TODAS';
			}
			
			if(nombreSucursal=='0'){
				nombreSucursal='TODAS';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}

			if(nombreMoneda=='0'){
				nombreMoneda='TODOS';
			}else{
				nombreMoneda = $("#monedaID option:selected").html();
			}

			if(nombreGenero=='0'){
				nombreGenero='TODOS';
			}else{
				nombreGenero =$("#genero option:selected").html();
			}
		
			if(genero == '0'){
				genero = '';
				
			}else{
				genero = $("#sexo option:selected").val();
			}
			if(nombreTipocuenta=='0'){
				nombreTipocuenta='TODAS';
				
			}else{
				nombreTipocuenta = $("#tipoCuentaID option:selected").html();
			}
		
			
			$('#ligaGenerar').attr('href','ReporteAnaliticoAhorro.htm?'+'&clienteID='+
					clienteID+'&cuentasAho='+cuentasAho+'&monedaID='+monedaID+'&tipoCuentaID='+tipoCuentaID+'&FechaEmision='+fechaEmision+
					'&sucursal='+sucursal+'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&promotorID='+promotorID+'&sexo='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
					'&nombreCliente='+nombreCliente+'&nombreCuentaAho='+nombreCuentaAho+'&nombreTipocuenta='+nombreTipocuenta+	
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotorI='+nombrePromotorI+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+
					'&nombreMunicipio='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion);
		
		}
	}
	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#excel').attr("checked",false); 
			var tr= catTipoRepAnaliticoAhorro.PDF; 
			var clienteID = $("#clienteID").val();
			var cuentasAho = $("#cuentasAho").val();
			var sucursal = $("#sucursal option:selected").val();
			var monedaID = $("#monedaID option:selected").val();
					
			var tipoCuentaID=$("#tipoCuentaID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $("#promotorID").val();
			var genero =$("#sexo option:selected").val();
			var estadoID=$("#estadoID").val();
			var municipioID=$("#municipioID").val();
			var fechaEmision = parametroBean.fechaSucursal;
	
			
			/// VALORES TEXTO
			var nombreCliente = $("#nombreCliente ").val();
			var nombreSucursal = $("#sucursal option:selected").val();
			var nombreMoneda = $("#monedaID option:selected").val();
			  var nombreTipocuenta=$("#tipoCuentaID option:selected").val();
			  var nombreCuentaAho=$("#cuentasAho ").val();
			var nombreUsuario = parametroBean.claveUsuario; 
			var nombrePromotorI = $("#nombrePromotorI").val();
			var nombreGenero =$("#sexo option:selected").val();
			var nombreEstado=$("#nombreEstado").val();
			var nombreMunicipio=$("#nombreMuni").val();	
						var nombreInstitucion =  parametroBean.nombreInstitucion; 

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $("#sucursal option:selected").html();
			}

			if(nombreMoneda=='0'){
				nombreMoneda='';
			}else{
				nombreMoneda = $("#monedaID option:selected").html();
			}

			if(nombreGenero=='0'){
				nombreGenero='';
			}else{
				nombreGenero =$("#sexo option:selected").html();
			}
			if(genero=='0'){
				genero='';
			}

		
			if(nombreTipocuenta=='0'){
				nombreTipocuenta='';
				
			}else{
				nombreTipocuenta = $("#tipoCuentaID option:selected").html();
			}
						
			$('#ligaGenerar').attr('href','ReporteAnaliticoAhorro.htm?'+'&clienteID='+
					clienteID+'&cuentasAho='+cuentasAho+'&monedaID='+monedaID+'&tipoCuentaID='+tipoCuentaID+'&fechaEmision='+fechaEmision+
					'&sucursal='+sucursal+'&usuario='+usuario+'&tipoReporte='+tr+
					'&promotorID='+promotorID+'&genero='+genero+'&estadoID='+estadoID+'&municipioID='+municipioID+
					'&nombreCliente='+nombreCliente+'&nombreCuentaAho='+nombreCuentaAho+'&nombreTipocuenta='+nombreTipocuenta+	
					'&nombreSucursal='+nombreSucursal+'&nombreMoneda='+nombreMoneda+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotorI='+nombrePromotorI+'&nombreGenero='+nombreGenero+'&nombreEstado='+nombreEstado+
					'&nombreMunicipio='+nombreMunicipio+'&nombreInstitucion='+nombreInstitucion);
		

		}
	}


	//Funcion que consulta la cuenta de ahorro indicada 
	function consultaCtaAho() {
		var numCta = $('#cuentasAho').val();
		var tipConCampos= 31;
		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCta != '' && !isNaN(numCta) ){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){	
					if(cuenta.cuentaAhoID == '00000000000'){
						
						mensajeSis("La Cuenta es Institucional");
						$('#clienteID').val('0');
						$('#nombreCliente').val('TODOS');
						inicializaTodo();
						consultaTiposCuenta();
						$('#cuentasAho').val("");
						consultaSucursal();
						$('#clienteID').focus();
					}
					else{
					$('#cuentasAho').val(cuenta.cuentaAhoID);
					$('#tipoCuentaID').val(cuenta.tipoCuentaID);
					$('#clienteID').val(cuenta.clienteID);
					consultaCliente('clienteID');
					if(cuenta.sucursalID <=9){
						var sucur=cuenta.sucursalID;
						suc=sucur.substring(2,3);
					}else 
						if(cuenta.sucursalID<=99){
						var sucur=cuenta.sucursalID;
						suc=sucur.substring(1,3);
						}else{
							suc=cuenta.sucursalID;
						}
					$('#sucursal').val(suc);

					}
				
					
				}else{
					mensajeSis("No Existe la cuenta de ahorro");
					$('#tipoCuentaID').val("0");
					$('#clienteID').val("0");
					$('#nombreCliente').val("TODAS");
					$('#cuentasAho').val("");
					$('#cuentasAho').focus();
					$('#cuentasAho').select();	
					inicializaTodo();
				
				}
			});															
		}
	}

	function validaDirCliente() {
		var IdDireccion=6;
				var direccionesCliente ={
			 			'clienteID' : $('#clienteID').val(),
				};
				direccionesClienteServicio.consulta(IdDireccion,direccionesCliente,function(direccion) {
					if(direccion!=null){
						$('#estadoID').val(direccion.estadoID);
						$('#municipioID').val(direccion.municipioID);
						consultaEstado('estadoID');
						consultaMunicipio('municipioID');
					}else{
						mensajeSis("No Existe la direccion del Cliente");
						$('#tipoCuentaID').val("0");
						$('#clienteID').val("0");
						$('#nombreCliente').val("TODAS");
						$('#cuentasAho').val("");
						$('#clienteID').focus();
						$('#clienteID').select();	
						inicializaTodo();
					}
				});
			
			
		}
	
	function habilita(){
		habilitaControl('promotorID');
		habilitaControl('nombrePromotorI');
		habilitaControl('sexo');
		habilitaControl('estadoID');
		habilitaControl('nombreEstado');
		habilitaControl('municipioID');
		habilitaControl('nombreMuni');
	}
	function deshabilita(){
		deshabilitaControl('promotorID');
		deshabilitaControl('nombrePromotorI');
		deshabilitaControl('sexo');
		deshabilitaControl('estadoID');
		deshabilitaControl('nombreEstado');
		deshabilitaControl('municipioID');
		deshabilitaControl('nombreMuni');
	}
	function inicializaTodo(){
		$('#monedaID').val('0');
		$('#promotorID').val('0');
		$('#nombrePromotorI').val('TODOS');
		$('#estadoID').val('0');
		$('#nombreEstado').val('TODOS');
		$('#municipioID').val('0');
		$('#nombreMuni').val('TODOS');
		$('#sexo').val('0');
	}
});