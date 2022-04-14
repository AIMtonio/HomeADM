var cobraGarantiaFinanciada = "N";

var accedeHuella = 'N';
var huella_nombreCompleto,huella_usuarioID,huella_OrigenDatos, motivo, motivoID, bandera;
var parametroBean = consultaParametrosSession();
var serverHuella = new HuellaServer({
	fnHuellaValida:	function(datos){
			$('#contraseniaAut').val('HD>>'+datos.tokenHuella);
			grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'cliente', 'reiniciaForm', '');
		},
	fnHuellaInvalida: function(datos){
			return false;
		}
});

function validaUsuario() {
	var claveUsuario = $('#claveUsuarioAut').val();
	serverHuella.cancelarOperacionActual();
	$('#statusSrvHuella').hide();
	if(claveUsuario != ''){

		var usuarioBean = {
			'clave':claveUsuario
		};

		usuarioServicio.consulta(3, usuarioBean, function(usuario) {
				if(usuario!=null){

					accedeHuella = usuario.accedeHuella;
					huella_nombreCompleto = usuario.clave;
					huella_usuarioID = usuario.usuarioID;	
					huella_OrigenDatos = usuario.origenDatos;
					$('#cajaID').val(parametroBean.cajaID);	
					$('#sucursalID').val(parametroBean.sucursal);
					if(accedeHuella=='S'){
						$('#statusSrvHuella').show(500);
					}else{
						$('#statusSrvHuella').hide();
					}

				}else{
					mensajeSis('El Usuario Ingresado No Existe');
					accedeHuella=='N';
				}
			});
	}
}


listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente 			='CTE';

$(document).ready(function() {
	esTab = false;
	var cont =0;
		

	 // Indica que el tipo de bloqueo fue Garantia Liquida.
	
	
	$(':text').focus(function() {	
		esTab = false;
	});
 
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	deshabilitaBoton('agregar', 'submit');
	$("#clienteID").focus();
	
  $('#agregar').click(function() {
		creaDesbloq();
		$('#tipoTransaccion').val($('#operacion').val());
   });
   
   consultaCobraGarantiaFinanciada();

	$.validator.setDefaults({
   	submitHandler: function(event) {
    		if(validaVacios() == true){
	   		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'cliente', 'reiniciaForm', '');
 			}
 			$('#tipoTransaccion').val('2');
     		inicializaBotonBlo();
    	}
	});

	$('#clienteID').bind('keyup',function(e){
	   if(this.value.length >= 3){
		   lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	   }
   });

	$('#clienteID').blur(function(){
		accedeHuella == 'N';
		var cadena = $('#clienteID').val();
		expresionRegular = /^([0-9,%])*$/;

		if (esTab && !expresionRegular.test(cadena)){
			limpiarCampos();
			consultaCliente('clienteID');
			setTimeout("$('#cajaLista').hide();", 200);
			mensajeSis("No Existe el Socio");			
		}else{
			consultaCliente(this.id);
		}		
		
		if(  $('#numeroDetalle').val() > 0 ){ 
			eliminaDetalles();
			gridVacioDesbloqueos();
		}
	}); 
 	
	
 	$('#formaGenerica').validate({
		
		rules: {
			clienteID: 'required',	
			
		},

		messages: {
			
			clienteID: 'Especifique numero de cliente',
				
			}		
		});

	function validaVacios(){
		var retorno = true;
		cont =0;
		$('input[name=desbloquea]').each(function () {
			if ( $(this).is(':checked') ){
					cont++;				
				}
		}); 
		if (cont == 0){
			mensajeSis("Seleccione un monto a desbloquear");
			return false;
		}
		$('input[name=desbloquea]').each(function () {
			if ( $(this).is(':checked') ){
				cont++;
				var id =this.id.substring(10);
				var des =$('#descripcion'+id).val();
				if ( trim(des) == "" ){
					mensajeSis("Agrega una Descripción");
					$('#descripcion'+id).focus();
					retorno = false;
					return false;
				}
			}
		});
		if (retorno != false){
			if ($('#claveUsuarioAut').val() == ""){
				mensajeSis("Inserta la Clave de Usuario Autoriza");
				$('#claveUsuarioAut').focus();
				retorno = false;
				return false;
			}
			if(accedeHuella != 'S'){
				if ($('#contraseniaAut').val() == ""){
					mensajeSis("Inserta la Contraseña del Usuario Autoriza");
					$('#contraseniaAut').focus();
					retorno = false;
					return false;
				}else{
					bandera = 'N';
					$('#tipoTransaccion').val(2);
					$('#statusSrvHuella').hide();
				}
			}else{
				if($('#contraseniaAut').val() != ''){
					bandera = 'N';
					$('#tipoTransaccion').val(2);
				}else{
					bandera = 'S';
					$('#tipoTransaccion').val(2);
						serverHuella.funcionMostrarFirmaUsuario(
							huella_nombreCompleto,huella_usuarioID,huella_OrigenDatos
						); 
					retorno = false;
					return false;
				}
			}
		}
		return retorno;
	}

	
	function inicializaBotonBlo(){
		var filas =  $('#numeroDetCuentas').val();
		for(var i=1; i<=filas; i++) {
			var jqBotonBlo = eval("'#btnAgrega" + i + "'");
			var jqvarBloq = eval("'#varBloq"+ i + "'");
			estiloBloqueado(jqBotonBlo);
			$(jqvarBloq).val('B');
		}
	}
	
	function eliminaDetalles(){
		$('input[name=elimina]').each(function() {
			eliminaDetalle(this);
		});
		$('#numeroDetalle').val(0);
		$('#contenedorBloqueos').hide('slow');
	}

	function gridVacioDesbloqueos(){
		var div='<div id="gridAhoCte"></div>';
		$('#gridAhoCte').replaceWith(div);
	}
	
	function estiloBloqueado(idControl){
		$(idControl).css({'background' :'url(images/lock.png) no-repeat '});
		$(idControl).css({'border' :' none'});
		$(idControl).css({'width' :' 21px'});
		$(idControl).css({'height' :' 21px'});
	}

function consultaAhoCte(){
		if($('#clienteID').val()!=''){
			var params = {};
			params['tipoLista'] = 8;
			params['tipoTransaccion']= $('#operacion').val();
			params['clienteID'] = $('#clienteID').val();
			$.post("desbloqSaldoCtasGrid.htm", params, function(data){
				if(data.length >0) {
					$('#gridAhoCte').html(data);
					if($('#numeroDetCuentas').val()=='0'){
						$('#gridAhoCte').html("");
						if($('#operacion').val()==2){
							mensajeSis("No se encontraron cuentas o la cuenta no tiene saldo bloqueado ");
							deshabilitaBoton('agregar', 'submit');			
							$('#clienteID').select();		
							$('#clienteID').focus();
						}
						if($('#operacion').val()==1){
							mensajeSis("No se encontraron cuentas o la cuenta no tiene saldo Disponible ");
							deshabilitaBoton('agregar', 'submit');		
							$('#clienteID').select();		
							$('#clienteID').focus();
						}
					}
				
					inicializaBotonBlo();
					agregaFormatoControles('formaGenerica');
				}else{
					$('#gridAhoCte').html("");
					$('#contenedorBloqueos').html("");
				}
			});
		}
		else{
			$('#gridAhoCte').html("");
			$('#gridAhoCte').hide();
			$('input[name=elimina]').each(function() {
				eliminaDetalle(this);
			});
		}
	}

function consultaCliente(idControl) {
 	var jqCliente  = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();	
	var conCliente =1;
	var rfc = '';
	var tamanio = $(jqCliente).val().length;
	
	
	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numCliente != '' && !isNaN(numCliente)  && parseInt(tamanio)<11){
		clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
			if(cliente!=null){
				listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
				consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
				if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
				$('#contenedorBloqueos').hide('slow');					// Se agrega para ocultar el cuadro de dialogo de la lista de bloqueos
				$('#clienteID').val(cliente.numero);	
				$('#nombreCte').val(cliente.nombreCompleto);	
				$('#fechaMov').val(parametroBean.fechaSucursal);	
				if( $('#numeroDetalle').val()==0 && $('#tipoTransaccion').val()=='1'){
					$('#contenedorBloqueos').show('slow');
		 			agregaNuevoDetalle();
	 			
				}
				if(cliente.estatus=="I"){
					mensajeSis("El Cliente se encuentra Inactivo");
					$('#fechaMov').val('');		
					limpiarCampos();
				}else{

					$('#gridAhoCte').show();
					
					if( $('#numeroDetalle').val()==0 && $('#tipoTransaccion').val()=='2'){
						consultaAhoCte();
					}
				}
				}else{
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					
					limpiarCampos();
				}
			}else{
				limpiarCampos();
				mensajeSis("No Existe el Cliente");
			}    						
		});
	}
	else{
		limpiarCampos();
		} 
}
	function limpiarCampos(){
		$('#clienteID').focus();		
		$('#clienteID').val('');
		$('#nombreCte').val('');
		$('#contenedorBloqueos').hide('slow');		
		$('#contenedorBloqueos').html('');
		$('#gridAhoCte').html('');
		$('#gridAhoCte').hide();
		deshabilitaBoton('agregar', 'submit');
	}

	function creaDesbloq(){
		$('#lisDesbloq').val("");
		$('#lisCuentas').val("");
		$('#lisDesc').val("");
		$('#lisTipoD').val("");
		$('#lisMonto').val("");
		var numID = 0;
		var contador = 1;
		$('input[name=idBloqueo]').each(function() {
			numID = this.id.substring(9);
			if($('#desbloquea'+numID).is(':checked')) {
				if (contador != 1){
					$('#lisDesbloq').val($('#lisDesbloq').val() + ','  + this.value);
				}
				else{
					$('#lisDesbloq').val(this.value);
				}
				contador = contador + 1;	
			}
		});
		var contador = 1;
		$('input[name=cuentaAho]').each(function() {
			numID = this.id.substring(9);
			if($('#desbloquea'+numID).is(':checked')) {
				if (contador != 1){
					$('#lisCuentas').val($('#lisCuentas').val() + ','  + this.value);
				}
				else{
					$('#lisCuentas').val(this.value);
				}
				contador = contador + 1;	
			}
		});
		var contador = 1;
		$('input[name=ldescripcion]').each(function() {
			numID = this.id.substring(11);
			if($('#desbloquea'+numID).is(':checked')) {
				if (contador != 1){
					$('#lisDesc').val($('#lisDesc').val() + ','  + this.value);
				}
				else{
					$('#lisDesc').val(this.value);
				}
				contador = contador + 1;	
			}
		});
		
		var contador = 1;
		$('select[name=tiposBloqueoID]').each(function() {
			numID = this.id.substring(14);
			if($('#desbloquea'+numID).is(':checked')) {
				if (contador != 1){
					$('#lisTipoD').val($('#lisTipoD').val() + ','  + this.value);
				}
				else{
					$('#lisTipoD').val(this.value);
				}
				contador = contador + 1;	
			}
		});
		var contador = 1;
		$('input[name=lsaldoBloq]').each(function() {
			numID = this.id.substring(9);
			
			if($('#desbloquea'+numID).is(':checked')) {
				var valorMonto =$('#saldoBloq'+ numID).asNumber(); 
				
				if (contador != 1){
					$('#lisMonto').val($('#lisMonto').val() + ','  + valorMonto);
				}
				else{
					$('#lisMonto').val(valorMonto);
				}
				contador = contador + 1;	
			}
		});
	}

	comboLiquida();//llamada a función que llena la varialbe comboLiq para el tipo de bloqueo
	comboComun();//llamada a función que llena la varialbe comboCom para tipos de bloqueos
	comboFOGAFI();//llamada a función que llena la varialbe comboCom para tipos de bloueos

}); 

// fin de jquery //////////////////////////////////////////////////
var conTiposDesblo = {
		'principal' : 1,
		'depGarantia'	   : 2,
		'tiposDesbloqueo'	:3
	};
	
var numFila = 0;
	function agregaDetDesbloq(numGrid){
		
		var jqCuentaAhoAntes = eval("'#cuentaAho" + numGrid + "'");
		agregaNuevoDetalle();
		var filaActual=$('#numeroDetalle').val();
		var jqCuentaAhoDesp = eval("'#cuentaAho" + filaActual + "'");
		$(jqCuentaAhoDesp).val($(jqCuentaAhoAntes).val());
		consultaSaldoDisp(filaActual);   
	}
// funcion que se ejecuta al dar clic en el grid de CUENTAS llllll
	function desbloquearSaldoCta(numFila){
		
		var jqBotonBlo = eval("'#btnAgrega" + numFila + "'");
		var jqBtnHiden = eval("'#varBloq" + numFila + "'");
		var jqGrid = eval("'#grid" + numFila + "'");
		var jqEstatus =eval("'#estatus" + numFila + "'");
		var valorEstatus= $(jqEstatus).val();
		
		if(valorEstatus =='C'){
			mensajeSis("La cuenta se encuentra cancelada");			
		}else{				
			if(existenDesbloqueados()== false){
				
			}
			if( $(jqBtnHiden).val()=='B' ){
				estiloDesbloqueado(jqBotonBlo);
				$(jqBtnHiden).val('D');
				// nueva modificacion	
				consultaBloqueos(numFila);
				$('#contenedorBloqueos').show('slow');
				
				if(existenDesbloqueados()== false){
					$('#contenedorBloqueos').hide('slow');	
				}
				return false;
			}  
			if( $(jqBtnHiden).val()=='D' ){
				estiloBloqueado(jqBotonBlo);
				$(jqBtnHiden).val('B');
				consultaBloqueos(numFila);
				
				$('#contenedorBloqueos').hide('slow');
				$(jqGrid).val('');	
				if(existenDesbloqueados() == false){
					$('#contenedorBloqueos').hide('slow');	
				}
				return false;
			}  	  
		}
	}

	function estiloDesbloqueado(idControl){
		$(idControl).css({'background' :'url(images/unlock.png) no-repeat '});
		$(idControl).css({'border' :' none'});
		$(idControl).css({'width' :' 21px'});
		$(idControl).css({'height' :' 21px'});
	}

	function estiloBloqueado(idControl){
		$(idControl).css({'background' :'url(images/lock.png) no-repeat '});
		$(idControl).css({'border' :' none'});
		$(idControl).css({'width' :' 21px'});
		$(idControl).css({'height' :' 21px'});       
	}
 
	

	function existenDesbloqueados(){
		var retorno=false;
		$('input[name=varBloq]').each(function() {
			jqbloq= eval("'#" + this.id + "'");
			if($(jqbloq).val()=='D'){
				retorno = true;
			}
		});
		return retorno;
	}

	function existenMontosVacios(){
		var retorno=false;
		$('input[name=lmonto]').each(function() {
			jqMonto= eval("'#" + this.id + "'");
			if($(jqMonto).val()==''){
				retorno = true;
			}
		});
		return retorno;
	}		var jqGrid = eval("'#grid" + numFila + "'");
	
//// Nuevas Funciones
function consultaBloqueos(numFila){
	var cuentaAho = $('#cuentaAhoID'+numFila).val();
		
	if(cuentaAho !=''){
		var params = {};
		params['tipoLista'] = 3;
		params['cuentaAhoID'] = cuentaAho;

		$.post("desbloqSaldosGrid.htm", params, function(data){		
			if(data.length > 0) {
				$('#contenedorBloqueos').html(data);		
				agregaFormatoControles('formaGenerica');
				agregaFormatoMoneda('formaGenerica');
				habilitaBoton('agregar', 'submit');
			}else{
				mensajeSis("La Cuenta no tiene saldo bloqueado");
			}
		});
	}
	else{
		$('#contenedorBloqueos').html("");
		$('#contenedorBloqueos').hide();
		$('input[name=elimina]').each(function() {
			eliminaDetalle(this);
		});
	}
}
var comboLiq;
var comboCom;
var comboFOGAFI;
function buscaTiposBloqueos(idControl,idBloqueo){
	
	var depGarantiaLiquida=8;
	var depGarantiaFOGAFI = 20;
	if(idBloqueo == depGarantiaLiquida){
	
		dwr.util.removeAllOptions(idControl);
		dwr.util.addOptions(idControl, comboLiq, 'tiposBloqID', 'descripcion');
	}
	else if(idBloqueo == depGarantiaFOGAFI && cobraGarantiaFinanciada == 'S'){
		
		dwr.util.removeAllOptions(idControl);
		dwr.util.addOptions(idControl, comboFOGAFI, 'tiposBloqID', 'descripcion');
	}
	else{
		dwr.util.removeAllOptions(idControl);
		dwr.util.addOptions(idControl, comboCom, 'tiposBloqID', 'descripcion');
	}
	

}

/*inicio de las funciones que llenan las variables para el combo tipos desbloqueo*/
function comboLiquida(){
	
	var tiposBloqID = 0;
	var consulta= 2;
	
	var bloqueoBean = {
			'tiposBloqID' : tiposBloqID
		};
	
	 bloqueoSaldoServicio.tiposBloqueos(consulta,bloqueoBean,function(data){
		if(data!=null){
			comboLiq = data;
		}
	});

}


function comboComun(){
	
	var tiposBloqID = 0;
	var consulta= 3;
	
	var bloqueoBean = {
			'tiposBloqID' : tiposBloqID
		};
	
	 bloqueoSaldoServicio.tiposBloqueos(consulta,bloqueoBean,function(data){
		
		 if(data!=null){
			comboCom = data;
		}
	});

}

function comboFOGAFI(){
	
	var tiposBloqID = 0;
	var consulta= 4;
	
	var bloqueoBean = {
			'tiposBloqID' : tiposBloqID
		};
	
	 bloqueoSaldoServicio.tiposBloqueos(consulta,bloqueoBean,function(data){
		
		 if(data!=null){
			comboFOGAFI = data;
		}
	});

}

/*fin de las funciones que llenan las variables para el combo tipos desbloqueo*/

function consultaCtaAho(jqnumCta,jqcuentaDescrip) {
	var jqnumID = eval("'#"+jqnumCta+"'");
	var jqDescr = eval("'#"+jqcuentaDescrip+"'");
	var numCta = $(jqnumID).val(); 
	var retorno =false; 
	var tipConCampos= 4;
	var CuentaAhoBeanCon = {
		'cuentaAhoID'	:numCta
	};
	if(numCta != '' && !isNaN(numCta) ){		
		cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
			if(cuenta != null){
				$(jqDescr).val(cuenta.descripcionTipoCta);
			}else{
				mensajeSis("No Existe la cuenta de ahorro");
		 		$(jqnumCta).val('');
				$(jqnumCta).focus();	
		        retorno=true;
			}
		});															
	}
	return retorno;
}
function siguiente(idCtrl){
	var id = parseInt(idCtrl.substring(10));
	var next = id;
	if($('#descripcion'+next).val() == undefined){
		$('#claveUsuarioAut').focus();
	}else{
		$('#descripcion'+next).focus();
	}
}

function reiniciaForm(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
		mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 
			clearInterval(mensajeAlert); 
			$('#contenedorBloqueos').html('');
			$('#gridAhoCte').html('');
			$('#clienteID').focus();
			}
        }, 50);
	}
}




function generaSeccion(pageValor) {
	var cuentaAho = $('#cuentaAhoID'+numFila).val();
		
	if(cuentaAho !=''){
		var params = {};
		params['tipoLista'] = 3;
		params['cuentaAhoID'] = cuentaAho;
		params['page'] = pageValor;	

		$.post("desbloqSaldosGrid.htm", params, function(data){		
			if(data.length > 0) {
				$('#contenedorBloqueos').html(data);		
				agregaFormatoControles('formaGenerica');
				agregaFormatoMoneda('formaGenerica');
				habilitaBoton('agregar', 'submit');
			}else{
				mensajeSis("La Cuenta no tiene saldo bloqueado");
			}
		});	
	}
	else{
		$('#contenedorBloqueos').html("");
		$('#contenedorBloqueos').hide();
		$('input[name=elimina]').each(function() {
			eliminaDetalle(this);
		});
	}

}


function seleccionaTodas(){

	

		if( $('#selecTodas').is(":checked") ){
		   	$('input[name=desbloquea]').each(function() {
			$('#'+this.id).attr('checked', true);
			});
     }else{
		   	$('input[name=desbloquea]').each(function() {
			$('#'+this.id).attr('checked', false);
			});
   	}
			
			
}

function consultaCobraGarantiaFinanciada(){
	var tipoConsulta = 26;
	var bean = { 
			'empresaID'		: 1		
		};
	
	paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
			if (parametro != null){	
				cobraGarantiaFinanciada = parametro.valorParametro;				
				
			}else{
				cobraGarantiaFinanciada = 'N';
			}
			
	}});
}
