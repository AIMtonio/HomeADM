$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultaSucursal();
	$('#pdf').attr("checked",true) ; 
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#clienteID').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] =$('#clienteID').val();
		lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
	}); 
	
	 $('#cuentaAhoID').bind('keyup',function(e){
				 var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "clienteID";
					camposLista[1]="tipoCuentaID";
					camposLista[2]="institucionID";
					camposLista[3]="cuentaAhoID";
					parametrosLista[0] = $('#clienteID').val();
					parametrosLista[1]='0';
					parametrosLista[2]='0';
					parametrosLista[3]=$('#cuentaAhoID').val();
				listaAlfanumerica('cuentaAhoID', '2', '14', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');	
	});
	
	$('#clienteID').blur (function(){
		if($('#clienteID').asNumber()>0){
			$('#cuentaAhoID').val('0');
			$('#tipoCuenta').val('TODAS');

			consultaCliente(this.id);
		}else{
			setTimeout("$('#cajaLista').hide();", 200);

			$('#clienteID').val('0');
			$('#nombreCliente').val('TODOS');
			$('#cuentaAhoID').val('0');
			$('#tipoCuenta').val('TODAS');		
			consultaSucursal();		
		}
	});
	
	$('#cuentaAhoID').blur (function(){
		if($('#cuentaAhoID').asNumber()>0){
			consultaCtaAho(this.id);
		}else{
			setTimeout("$('#cajaLista').hide();", 200);
			$('#cuentaAhoID').val('0');
			$('#tipoCuenta').val('TODAS');
		}
	});

	$('#generar').click(function() { 
			if($('#pdf').is(":checked") ){
				generaPDF();
			}
			if($('#excel').is(":checked") ){
				generaExcel();
			}
		
	});
	
	 
	//------------ Validaciones de Controles -------------------------------------

	//Función que consulta el Nombre del Cliente
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(varclienteID != '' && !isNaN(varclienteID)){
			clienteServicio.consulta(conCliente,varclienteID,rfc,function(cliente){
				if(cliente!=null){		
					$('#clienteID').val(cliente.numero);
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
					$('#sucursalID').val(cliente.sucursalOrigen);					
					consultaSucursal(cliente.sucursalOrigen);
				
				}else{
					alert("No Existe el Cliente");
					$(jqCliente).focus();
					$('#cuentaAhoID').val("0");
					$('#tipoCuenta').val("TODAS");
					$(jqCliente).val('0');
					$('#nombreCliente').val("TODOS");
					$('#sucursalID').val('0');
					$('#nombreSucursal').val('TODAS');
					
				}    						
			});
		}
	}	
	//Función que Consulta la Descripción de la Cuenta de Ahorro
	function consultaCtaAho(idControl) {
		var jqCtaAho = eval("'#" + idControl + "'");
		var numCtaAho = $(jqCtaAho).val();
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCtaAho
		};
		var conCtaAho = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCtaAho != '' && !isNaN(numCtaAho) && esTab) {
			cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho) {
				if (ctaAho != null) {
					$('#cuentaAhoID').val(ctaAho.cuentaAhoID);
					$('#tipoCuenta').val(ctaAho.descripcionTipoCta);
					$('#clienteID').val(ctaAho.clienteID);
					consultaCliente('clienteID');
			
				} else {
					alert("No Existe la Cuenta de Ahorro");
					$(jqCtaAho).focus();
					$('#cuentaAhoID').val("0");
					$('#tipoCuenta').val("TODAS");
				}
			});
		}
	}
	
	function consultaSucursal(numSucursal) {
		var consultaPrincipal = 1;
		if (numSucursal != '' && !isNaN(numSucursal)) {

			sucursalesServicio.consultaSucursal(consultaPrincipal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#nombreSucursal').val(
									sucursal.nombreSucurs);

						} else {
							alert("No Existe la Sucursal");
							$('#sucursal').val(0);
							$('#nombreSucursal').val('');
						}
					});
		} else {
			$('#sucursalID').val('0');
			$('#nombreSucursal').val('TODAS');
		}
	}
	
	//Función para generar Reporte en Excel
	function generaExcel() {
			$('#pdf').attr("checked",false); 
			var tr=2;
			var horaSuc=hora();
			var nomSuc=$("#sucursalID").val() + " - " + $('#nombreSucursal').val();
			var nomCli="";
			var nomCta="";
			if ($('#clienteID').asNumber()>0){
				nomCli=$('#clienteID').val()+" - "+ $('#nombreCliente').val();
				var ClienteConCaracter = nomCli;
				nomCli = ClienteConCaracter.replace(/\&/g, "%26");	
			}else{
				nomCli=$('#nombreCliente').val();
			}
			if ($('#clienteID').asNumber()>0){
				nomCta=$('#cuentaAhoID').val()+" - "+$('#tipoCuenta').val();
			}else{
				nomCta=$('#tipoCuenta').val();
			}
			
			$('#ligaGenerar').attr('href','reporteBloqueoSaldos.htm?'+
			'&sucursalID='			+$("#sucursalID").val()+
			'&clienteID='			+$('#clienteID').val()+
			'&cuentaAhoID='			+$('#cuentaAhoID').val()+
			'&nombreInstitucion='	+parametroBean.nombreInstitucion+
			'&nombreUsuario='		+parametroBean.claveUsuario+
			'&fecha='				+parametroBean.fechaAplicacion+
			'&nombreSucursal='		+nomSuc+
			'&nombreCliente='		+nomCli+
			'&descripcion='			+nomCta+
			'&claveUsuario='		+parametroBean.claveUsuario+
			'&hora='				+horaSuc+
			'&fechaEmision='		+parametroBean.fechaAplicacion+
			'&tipoReporte='			+tr);	
	}
	//Función para generar Reporte en PDF
	function generaPDF() {		
			$('#excel').attr("checked",false); 
			var tr=1;
			nomCli=$('#nombreCliente').val();
			var ClienteConCaracter = nomCli;
			nomCli = ClienteConCaracter.replace(/\&/g, "%26");
			$('#ligaGenerar').attr('href','reporteBloqueoSaldos.htm?'+
			'&sucursalID='			+$("#sucursalID").val()+
			'&clienteID='			+$('#clienteID').val()+
			'&cuentaAhoID='			+$('#cuentaAhoID').val()+
			'&nombreInstitucion='	+parametroBean.nombreInstitucion+
			'&nombreUsuario='		+parametroBean.claveUsuario+
			'&fecha='				+parametroBean.fechaAplicacion+
			'&nombreSucursal='		+$('#nombreSucursal').val()+
			'&nombreCliente='		+nomCli+
			'&descripcion='			+$('#tipoCuenta').val()+
			'&tipoReporte='			+tr);
	}
	// funcion para obtener la hora del sistema
	function hora(){
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		 
		 if (minutes<=9)
			 minutes="0"+minutes;
		 if (seconds<=9)
			 seconds="0"+seconds;
		return  hours+":"+minutes+":"+seconds;
	 }
});