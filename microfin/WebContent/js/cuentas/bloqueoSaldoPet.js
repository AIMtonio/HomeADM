var cuentaAhorro = "";
var cobraGarantiaFinanciada = "N";

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
	$("#clienteID").focus();
	esTab = true;
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
    var catTipoBloqueo = {
	  		'bloqueo':'1',
	  		'desbloqueo':'2'
    };
    $('#contenedorBloqueos').hide();	
	$('#fechaMov').val(parametroBean.fechaSucursal);
	consultaCobraGarantiaFinanciada();	// Llamada a la funcion para obtener si la institución cobra o no garantia financiada
    
    $(':text').focus(function() {	
    	esTab = false;
    });
  
   $(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
   
   
   
   /* ===================== MANEJO DE EVENTOS =================================0*/

  	$('#clienteID').blur(function(){
  		consultaCliente('clienteID');
		if(  $('#numeroDetalle').val() > 0 ){ 
			eliminaDetalles();
			gridVacioDesbloqueos();
		} 
	}); 
	
   $('#clienteID').bind('keyup',function(e){
	   if(this.value.length >= 3){
		   lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	   }
   });
   $('#agregar').click(function() {		
	   $('#tipoTransaccion').val($('#operacion').val());
   });

   
   $.validator.setDefaults({
    submitHandler: function(event) {
    	if(validaGridVacios()==true){ 
		    		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'cliente');	   
			if($('#tipoTransaccion').val()=='1'){
				eliminaDetalles(); 
			 }
			  if($('#tipoTransaccion').val()=='2'){
				  eliminaDetalles(); 
			  	}
		 }
	 $('#tipoTransaccion').val('2');
	     inicializaBotonBlo();
	    }
   });	

   
   
   
    /* ============================== METODOS Y FUNCIONES   =============================== */ 
   
	 function consultaCliente(idControl) {
	 	var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =1;
		var rfc = '';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && numCliente > 0 && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){
					listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
					$('#clienteID').val(cliente.numero);	
					$('#nombreCte').val(cliente.nombreCompleto);	
					$('#fechaMov').val(parametroBean.fechaSucursal);	
					if( $('#numeroDetalle').val()==0 && $('#tipoTransaccion').val()=='1'){
						$('#contenedorBloqueos').show('slow');
			 			agregaNuevoDetalle();	 				 			
		 		
					}	
					if(cliente.estatus=="I"){
						mensajeSis("El Cliente se encuentra Inactivo");
						$('#clienteID').val('');
						$('#nombreCte').val('');
						$('#fechaMov').val('');		
						$('#clienteID').focus();
						$('#contenedorBloqueos').hide('slow');
						$('#gridAhoCte').hide();
					}else{
						if( $('#numeroDetalle').val()==0 && $('#tipoTransaccion').val()=='2'){
							consultaAhoCte();
						}
						$('#gridAhoCte').show();
					}
					}else{
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						
						inicializaForma('formaGenerica', 'clienteID');
						$(jqCliente).focus();
						$('#nombreCte').val('');
						$(jqCliente).val('');
						$('#contenedorBloqueos').hide('slow');
					}
				}else{
					mensajeSis("No Existe el Cliente");
					$(jqCliente).focus();
					$('#nombreCte').val('');
					$(jqCliente).val('');
					$('#contenedorBloqueos').hide('slow');
				}    						
			});
		}
	}


	$('#formaGenerica').validate({		
		rules: {
			clienteID: 'required',				
		},		
		messages: {			
			clienteID: 'Especifique número de cliente',			
			}		
	});
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
		 eliminaDetalles();
	
	}
	
	function inicializaBotonBlo(){
		 var filas =  $('#numeroDetCuentas').val();
	
		 for(var i=1; i<=filas; i++){
			   var jqBotonBlo = eval("'#btnAgrega" + i + "'");
		   var jqvarBloq = eval("'#varBloq"+ i + "'");
		   var jqgrid = eval("'#grid"+ i + "'");
		   estiloBloqueado(jqBotonBlo);
		   $(jqvarBloq).val('B');
		   $(jqgrid).val('');
			}
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
						if($('#operacion').val()==2)mensajeSis("No se encontraron cuentas o la cuenta no tiene saldo bloqueado ");
						if($('#operacion').val()==1)mensajeSis("No se encontraron cuentas o la cuenta no tiene saldo Disponible ");
						$('#clienteID').val('');
						$('#nombreCte').val('');
						$('#clienteID').focus();
					}
					
					
					inicializaBotonBlo();
					agregaFormatoControles('formaGenerica');
				}else{
					$('#gridAhoCte').html("");				
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

		   
});
   //FIN DE jQuery


	function estiloBloqueado(idControl){
		$(idControl).css({'background' :'url(images/lock.png) no-repeat '});
		$(idControl).css({'border' :' none'});
		$(idControl).css({'width' :' 21px'});
		$(idControl).css({'height' :' 21px'});         
	 }
	
	function buscaTiposBloqueos(idControl){
		var tiposBloqID = 0;
	    var principal=1;
;
	
		var bloqueoBean = {
	   			'tiposBloqID' : tiposBloqID
	    };
	   
		bloqueoSaldoServicio.tiposBloqueos(principal,bloqueoBean,function(data){
			if(data!=null){
				dwr.util.removeAllOptions(idControl);
				dwr.util.addOptions(idControl, data, 'tiposBloqID', 'descripcion');	
				$("#"+idControl+' option[value=8]').attr('selected','true');
		
			}else{				
				mensajeSis("No existe la requisicion: "+numRequisicion);
				$('#clienteID').focus();					
							
			}	
		});	
			
				
	}

	function validaGridVacios(){
		var retorno = true;
		$('input[name=elimina]').each(function() {
			if(validaCamposVacios(this.id)==false){
				retorno = false;
				return false;
				}
				
		});	
		if (retorno==true){
			var cuentasGrid= arregloDeCuentas();
			for (var i = 1; i < cuentasGrid.length; i++) {
			         
			         if( validaSumaMontosbloq(cuentasGrid[i]) == false){
			         	retorno = false;
							return false;
			         }         	
			 }
		}
	
		
		 function arregloDeCuentas(){
			var cuentasGrid = new Array();
			var contador=1;	
			var existe;
			$('input[name=elimina]').each(function() {
				var jqcuentaAho = eval("'#cuentaAho" + this.id + "'");
				existe=false;
				for (var i = 1; i < cuentasGrid.length; i++) {
				    if(cuentasGrid[i]== $(jqcuentaAho).val()){
				    	 existe=true;	
					}            	
				}
				 if(existe==false){
					 cuentasGrid[contador]= $(jqcuentaAho).val();
					 contador ++;
				}
			  	
			});
		 	return cuentasGrid;
		 }
	
		function convierteStrInt(jControl){
			var valor=($(jControl).formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
				})).asNumber();
			return  parseFloat(valor);
		} 
		function validaSumaMontosbloq(numCuenta){
			var saldoBloq=0.00;
			var saldoDispon=0.00;
			var monto=0.00;
				
			var totalSaldoDisp=0.00;
			var totalSaldoBloq=0.00;
			var totalMonto=0.00;
			$('input[name=elimina]').each(function() {
				var numFila = this.id;
				var jqcuentaAho = eval("'#cuentaAho" + numFila + "'");
			 
				if($(jqcuentaAho).val()==numCuenta){ 		///////////////
					var jqsaldoDispo = eval("'#saldoDispo" + numFila + "'");
					var jqsaldoBloq = eval("'#saldoBloq" + numFila + "'");	
					var jqMonto = eval("'#monto" + numFila + "'");
					saldoBloq=0.00; saldoDispon=0.00; monto=0.00;
				   
					saldoBloq=convierteStrInt(jqsaldoBloq);
					saldoDispon=convierteStrInt(jqsaldoDispo);
					monto=convierteStrInt(jqMonto);
				
					totalSaldoDisp = saldoDispon;
					totalSaldoBloq = saldoBloq;
					totalMonto += monto;
				} 	 //////////////////////////////////////////////
			});	
			function convierteStrInt(jControl){
				var valor=($(jControl).formatCurrency({
								positiveFormat: '%n', 
								roundToDecimalPlace: 2	
								})).asNumber();
		
				return  parseFloat(valor);
		
			} 	
			if($('#tipoTransaccion').val()=='1'){
			  if(totalMonto>totalSaldoDisp){
			  	mensajeSis('La suma de los montos: '+totalMonto+' es mayor que el saldo disponible: '+saldoDispon+' de la cuenta: '+numCuenta);
			  	  	
			    	 return false;
			  	  	}
			  }
		
			if($('#tipoTransaccion').val()=='2'){
				if(totalMonto>totalSaldoBloq){
					mensajeSis('La suma de los montos: '+totalMonto+' es mayor que el saldo bloqueado: '+saldoBloq+' de la cuenta: '+numCuenta);		  	  	 
				    	 return false;
				 }
				}		  
			return true;	  	
		}
		
		function validaCamposVacios(numeroID){
			var jqcuentaAho = eval("'#cuentaAho" + numeroID + "'");
			var jqcuentaDescrip = eval("'#cuentaDescrip" + numeroID + "'");		
			var jqsaldoDispo = eval("'#saldoDispo" + numeroID + "'");
			var jqsaldoBloq = eval("'#saldoBloq" + numeroID + "'");
			var jqsaldoSBC = eval("'#saldoSBC" + numeroID + "'");
			var jqdescripcion = eval("'#descripcion" + numeroID + "'");
			var jqreferencia = eval("'#referencia" + numeroID + "'");	
		
			var jqMonto = eval("'#monto" + numeroID + "'");
			var saldoBloq=convierteStrInt(jqsaldoBloq);
			var saldoDispon=convierteStrInt(jqsaldoDispo);
			var monto=convierteStrInt(jqMonto);
		
			if( $(jqsaldoSBC).val()==''){
				mensajeSis("La cuenta no es válida.");
				$(jqcuentaAho).focus();
				return false;  	
			}
			if( $(jqsaldoBloq).val()==''){
				mensajeSis("La cuenta no es válida.");
				$(jqcuentaAho).focus();
				return false;  	
			}
			if( $(jqsaldoDispo).val()==''){
				mensajeSis("La cuenta no es válida.");
				$(jqcuentaAho).focus();
			return false;	
			}
			
			if( $(jqdescripcion).val()==''){
				mensajeSis("Agregue una descripción. ");
				$(jqdescripcion).focus();
				return false;  	
			}
		  
			if( $(jqreferencia).val()==''){
			  mensajeSis("Agregue una referencia. ");
			  $(jqreferencia).focus();
			  return false;			  	
			}
			
			if( isNaN($(jqreferencia).val())){
				  mensajeSis("Sólo dígitos numéricos");
				  $(jqreferencia).val('');
				  $(jqreferencia).focus();
				  return false;			  	
				}
			
			if( $(jqMonto).val()=='' || $(jqMonto).val()=='0.00'){
				mensajeSis("Agregue el monto. ");
				$(jqMonto).focus();
				return false;  	
			}
			if($('#operacion').val()=='1'){
				if(monto>saldoDispon){
					mensajeSis('Imposible bloquear saldo. El monto es mayor al saldo disponible.');
					$(jqMonto).focus();
					return false;
				}
			}
		
			if($('#operacion').val()=='2'){
				if(monto>saldoBloq){
					mensajeSis('Imposible desbloquear saldo. El monto es mayor al saldo bloqueado.');
					$(jqMonto).focus();
		    	 return false;
		  	  	}
		  	}
		  	
			
			return true;
		}
		
	return retorno;
	}

	function Validador(e){
		key=(document.all) ? e.keyCode : e.which;
		if (key < 48 || key > 57 || key == 46){
			if (key==8|| key == 46 || key == 0){
				return true;
			}
			else 
				mensajeSis("Sólo se pueden ingresar números");
	  		return false;
		}
	}   	

	function validaMontoNeg(idControl){
		var jsmonto=	eval("'#monto" + idControl + "'");
		var monto=$(jsmonto).val();
	
		if(monto.indexOf("($") != -1){
			$(jsmonto).val('');
		}
	}
	

	
	function agregaNuevoDetalle(){
		var numeroFila = document.getElementById("numeroDetalle").value;
		var nuevaFila = parseInt(numeroFila) + 1;	
		var tipoTransaccion = $('#tipoTransaccion').val();
		if(numeroFila > 0 && tipoTransaccion=='1' ){
			if ( validaCamposVacios(numeroFila)==false ) return false;
		}
		var  td= '<tr id="renglon' + nuevaFila + '" name="renglon">';
		if(tipoTransaccion=='1'){
			td += '<td><input type="text" id="consecutivoID'+nuevaFila+'" disabled="true" name="consecutivoID" size="3" value="'+nuevaFila+'" autocomplete="off" /></td>';
		}else{
			td+="<td></td>";
		}	   
		td+='<td nowrap="nowrap">';
		td+='<input type="text" id="cuentaAho'+nuevaFila+'"  name="lcuentaAho" path="cuentaAho" size="13"  readonly="true" />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="cuentaDescrip'+nuevaFila+'"  path="cuentaDescrip" name="cuentaDescrip" size="23"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="saldoDispo'+nuevaFila+'" style="text-align:right;" size="12" name="lsaldoDispo" path="saldoDispo"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="saldoBloq'+nuevaFila+'" style="text-align:right;" size="12" name="lsaldoBloq" path="saldoBloq"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="saldoSBC'+nuevaFila+'" style="text-align:right;" size="12" name="lsaldoSBC" path="saldoSBC"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="descripcion'+nuevaFila+'" name="ldescripcion" size="23" path="descripcion" onBlur="ponerMayusculas(this); limpiarCajaTexto(this.id);" maxlength="140"/>';
		td+='</td>';
		td+='<td>';
		td+='<select id="tiposBloqueoID'+nuevaFila+'" name="tiposBloqueoID" path="tiposBloqueoID">';
		td+='<option value="1">ERROR</option>';
		td+='</select>';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="referencia'+nuevaFila+'" name="lreferencia" size="20" path="referencia" maxlength="15" onblur="consultaMontoGL(this.id,'+nuevaFila+');" onKeyUp="listaCreditos(this.id,'+nuevaFila+');"';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="monto'+nuevaFila+'" style="text-align:right;" size="12" onkeyPress="return Validador(event);" esMoneda="true"   onKeyUp="validaMontoNeg(\''+nuevaFila+'\');" name="lmonto" path="monto" onBlur="validaMontoNeg(\''+nuevaFila+'\');"/>';
		td+='</td>';
		td+='<td align="center" nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalle(this)"/>';
		if(tipoTransaccion=='1'){
			td+='<input type="button" name="agrega" id="agrega'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoDetalle();"/>';
		}
		if(tipoTransaccion=='2'){
			td+='<input type="button" name="agrega" id="agrega'+nuevaFila +'" class="btnAgrega" onclick="agregaDetDesbloq(\''+nuevaFila+'\');"/>';
		}
		td+='</td>';
		td+='</tr>';  
	
		document.getElementById("numeroDetalle").value = nuevaFila;    	
		$("#miTabla").append(td);
	
		var idControl =  eval("'tiposBloqueoID" + nuevaFila + "'");	
		
		buscaTiposBloqueos(idControl);
	
		agregaFormatoControles('formaGenerica');
	} 
  
	function agregaDisabled (idControl){
	 	$(idControl).css({'background-color' : '#E6E6E6',"color":"#545454"});
	 	$(idControl).attr('readOnly','true');  	
	} 	   
   
	function eliminaDetalle(control){		
		var numeroID = control.id;
		var jqTr = eval("'#renglon" + numeroID + "'");
	
		var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");	
		var jqcuentaAho = eval("'#cuentaAho" + numeroID + "'");
		var jqcuentaDescrip = eval("'#cuentaDescrip" + numeroID + "'");		
		var jqsaldoDispo = eval("'#saldoDispo" + numeroID + "'");
		var jqsaldoBloq = eval("'#saldoBloq" + numeroID + "'");
		var jqsaldoSBC = eval("'#saldoSBC" + numeroID + "'");
		var jqdescripcion = eval("'#descripcion" + numeroID + "'");	
		var jqMonto = eval("'#monto" + numeroID + "'");
	
		var jqElimina = eval("'#" + numeroID + "'");
		var jqAgrega = eval("'#agrega" + numeroID + "'");
	
		var jqConsecutivoIDAnt = eval("'#consecutivoID" + String(eval(parseInt(numeroID)-1)) + "'");				
		var jqConsecutivoIDSig = eval("'#consecutivoID" + String(eval(parseInt(numeroID)+1)) + "'");										  					
	
	//Si es el primer Elemento
		if ($(jqConsecutivoID).attr("id") == $("input[name=consecutivoID]:first-child").attr("id")){	
			$(jqConsecutivoIDSig).val("1");				
		}else if($(jqConsecutivoIDSig).val()!= null && $(jqConsecutivoIDSig).val()!= undefined && $('#tipoTransaccion').val=='1') {
			//Valida Antes de actualizar, que si exista un sig elemento
			for (i=(parseInt(numeroID)+1);i<=$("#numeroDetalle").val();i++){
				jqConsecutivoIDSig = eval("'#consecutivoID" + i + "'");			 		 	
				$(jqConsecutivoIDSig).val(numeroID);
				numeroID++;
			}
		}		
		
		$(jqConsecutivoID).remove();
		$(jqcuentaAho).remove();
		$(jqcuentaDescrip).remove();
		$(jqsaldoDispo).remove();
		$(jqsaldoBloq).remove();
		$(jqsaldoSBC).remove();
		$(jqdescripcion).remove();
		$(jqMonto).remove();
		
		$(jqElimina).remove();
		$(jqAgrega).remove();
		$(jqTr).remove();
		
		if($('#tipoTransaccion').val()=='1'){	
			//Reordenamiento de Controles
			var contador = 1;
			$('input[name=consecutivoID]').each(function() {		
				var jqCicInf = eval("'#" + this.id + "'");	
				$(jqCicInf).attr("id", "consecutivoID" + contador);			
				contador = contador + 1;	
			});
	
			//Reordenamiento de Controles
			contador = 1;
			$('input[name=lcuentaAho]').each(function() {		
				var jqCicInf = eval("'#" + this.id + "'");	
				$(jqCicInf).unbind();	
				$(jqCicInf).attr("id", "cuentaAho" + contador);		
				
				contador = contador + 1;	
			});
	
			//Reordenamiento de Controles
			contador = 1;
			$('input[name=cuentaDescrip]').each(function() {
				var jqCicInf = eval("'#" + this.id + "'");	
				$(jqCicInf).unbind();	
				$(jqCicInf).attr("id", "cuentaDescrip" + contador);			
				contador = contador + 1;	
			});			
	
			//Reordenamiento de Controles		
			contador = 1;		
			$('input[name=ldescripcion]').each(function() {		
				var jqCicSup = eval("'#" + this.id + "'");
				$(jqCicSup).unbind();			
				$(jqCicSup).attr("id", "descripcion" + contador);			
				contador = contador + 1;
			});
	
	
			//Reordenamiento de Controles		
			contador = 1;		
			$('input[name=lsaldoDispo]').each(function() {		
				var jqCicSup = eval("'#" + this.id + "'");
				$(jqCicSup).unbind();			
				$(jqCicSup).attr("id", "saldoDispo" + contador);			
				contador = contador + 1;
			});
	
			//Reordenamiento de Controles		
			contador = 1;		
			$('input[name=lsaldoBloq]').each(function() {		
				var jqCicSup = eval("'#" + this.id + "'");
				$(jqCicSup).unbind();			
				$(jqCicSup).attr("id", "saldoBloq" + contador);			
				contador = contador + 1;
			});
	
			//Reordenamiento de Controles		
			contador = 1;		
			$('input[name=lmonto]').each(function() {		
				var jqCicSup = eval("'#" + this.id + "'");
				$(jqCicSup).unbind();			
				$(jqCicSup).attr("id", "monto" + contador);			
				contador = contador + 1;
			});
	
	
			//Reordenamiento de Controles		
			contador = 1;		
			$('input[name=lsaldoSBC]').each(function() {		
				var jqCicSup = eval("'#" + this.id + "'");
				$(jqCicSup).unbind();			
				$(jqCicSup).attr("id", "saldoSBC" + contador);			
				contador = contador + 1;
			});
	
	
			//Reordenamiento de Controles	
			contador = 1;		
			$('input[name=agrega]').each(function() {
				var jqAgrega = eval("'#" + this.id + "'");			
				$(jqAgrega).attr("id", "agrega" + contador);
				contador = contador + 1;	
			});		
				
			//Reordenamiento de Controles
			contador = 1;
			$('input[name=elimina]').each(function() {
				var jqCicElim = eval("'#" + this.id + "'");
				$(jqCicElim).attr("id", contador);
				contador = contador + 1;	
			});			
	
			//Reordenamiento de Controles
			contador = 1;		
			$('tr[name=renglon]').each(function() {
				var jqCicTr = eval("'#" + this.id + "'");			
				$(jqCicTr).attr("id", "renglon" + contador);
				contador = contador + 1;	
			});
			//
			$('#numeroDetalle').val($('#numeroDetalle').val()-1);	
				if($('#numeroDetalle').val()==0){
				}
		}
	
	}

	function listaCuentas(idControl) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		listaAlfanumerica(idControl, '0', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');	
	      
	}
	

	
function consultaSaldoDisp(numFila) {
	var jqnumCta = eval("'#cuentaAho" + numFila + "'");
	var jqsaldoDispon = eval("'#saldoDispo" + numFila + "'");
	var jqsaldoSBC = eval("'#saldoSBC" + numFila + "'");
	var jqsaldoBloq = eval("'#saldoBloq" + numFila + "'");
	var jqcuentaDescrip = eval("'#cuentaDescrip" + numFila + "'");
	var error=false;
	var	numCta = $(jqnumCta).val();  
	var cliente =  $('#clienteID').val();
	var tipConCampos= 5;
	var CuentaAhoBeanCon = {
            'cuentaAhoID':numCta,
            'clienteID':cliente
	};
      
  if(numCta != '' && !isNaN(numCta) && true){
     cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, function(cuenta) {
         if(cuenta.saldoDispon!=null){
          		if (cuenta.clienteID==cliente){
            		$(jqsaldoDispon).val(cuenta.saldoDispon);
            		
            		$(jqsaldoSBC).val(cuenta.saldoSBC);
            		$(jqsaldoBloq).val(cuenta.saldoBloq);
               
                if( consultaCtaAho(jqnumCta,jqcuentaDescrip)==true){
							   error=true;             	
						}                    	
               
              }
              else{
	          	error=true;   
					}   
         }
         else{
          		error=true;
			}
            
     });                                                                                                                        
  }
 
  if(error==true){
	  mensajeSis("Cuenta no asociada al Cliente.");
	  $(jqsaldoDispon).val("");
	  $(jqsaldoSBC).val("");
	  $(jqsaldoBloq).val("");
	  $(jqcuentaDescrip).val(""); 
	  $(jqnumCta).val('');
	  $(jqnumCta).focus();  	
	}      	
}
			
	function consultaCtaAho(jqnumCta,jqcuentaDescrip) {
		var	numCta = $(jqnumCta).val(); 
		var retorno =false; 
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
		'cuentaAhoID'	:numCta
		};
	
		
		if(numCta != '' && !isNaN(numCta) ){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {	
				if(cuenta!=null){	
					$(jqcuentaDescrip).val(cuenta.descripcionTipoCta);																	
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
	function existenMontosVacios(){
		var retorno=false;
		$('input[name=lmonto]').each(function() {
			jqMonto= eval("'#" + this.id + "'");	
			if($(jqMonto).val()==''){
					retorno = true;
			}
		});
	
		return retorno;
	}

	function desbloquearSaldoCta(numFila){
		
		var jqBotonBlo = eval("'#btnAgrega" + numFila + "'");
		var jqBtnHiden = eval("'#varBloq" + numFila + "'");
		var jqGrid = eval("'#grid" + numFila + "'");
		var jqEstatus= eval("'#estatus" + numFila + "'");
		var valorEstatus= $(jqEstatus).val();
		
		if(valorEstatus =='C'){
			mensajeSis("La cuenta se encuentra cancelada");			
		}else{
			if(existenDesbloqueados()== false){
			}
			if( $(jqBtnHiden).val()=='B' ){
				estiloDesbloqueado(jqBotonBlo);
				$(jqBtnHiden).val('D');
				
				$('#contenedorBloqueos').show('slow');
				agregaNuevoDetalle();
				agregaDatosDetalle(numFila); 
				if(existenDesbloqueados()== false){
					$('#contenedorBloqueos').hide('slow');	
				}	
				return false;
			}  
			if( $(jqBtnHiden).val()=='D' ){
				estiloBloqueado(jqBotonBlo);
				$(jqBtnHiden).val('B');
				var numGrid = $(jqGrid).val();
				var detalle =null;
				$('input[name=elimina]').each(function() {
					if(this.id==numGrid){
						detalle=this;
					}
				});
				eliminaDetalle(detalle);
				$(jqGrid).val('');	
				if(existenDesbloqueados()== false){
					$('#contenedorBloqueos').hide('slow');	
				}
				return false;
			}  	   
		} // else cta cancelada
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
	function estiloDesbloqueado(idControl){
		$('#desbloquear').css({'background' :'url(images/unlock.png) no-repeat '});
		$(idControl).css({'border' :' none'});
		$(idControl).css({'width' :' 21px'});
		$(idControl).css({'height' :' 21px'});
	}

	function agregaDatosDetalle(numFila){
		var numGrid=$('#numeroDetalle').val();
		var jqCuentaBlo = eval("'#cuentaAhoID" + numFila + "'");
		var jqGrid = eval("'#grid" + numFila + "'");
		var jqVuentaAhoGrid = eval("'#cuentaAho" + numGrid + "'");
		$(jqVuentaAhoGrid).val($(jqCuentaBlo).val());
		$(jqGrid).val(numGrid);
		consultaSaldoDisp(numGrid);
	}
	function agregaDetDesbloq(numGrid){
		var jqCuentaAhoAntes = eval("'#cuentaAho" + numGrid + "'");
		agregaNuevoDetalle();
		var filaActual=$('#numeroDetalle').val();
		var jqCuentaAhoDesp = eval("'#cuentaAho" + filaActual + "'");
		$(jqCuentaAhoDesp).val($(jqCuentaAhoAntes).val());
		consultaSaldoDisp(filaActual);   
	}


	function listaCreditos(id, numeroFila){
		var numCliente = $('#clienteID').asNumber();
		var jqControl = eval("'#tiposBloqueoID" + numeroFila + "'");
		var tipoBloqueo = $(jqControl).val();
				
		// Lista de creditos que deben garantia liquida
		if(numCliente !='' && parseInt(tipoBloqueo) == 8){
			lista(id, '2', '19', 'clienteID',numCliente, 'ListaCreditoNoDes.htm');			
		}

		if(cobraGarantiaFinanciada == 'S'){
			// Lista de creditos que deben garantia FOGAFI
			if(numCliente !='' && parseInt(tipoBloqueo) == 20){
				lista(id, '2', '55', 'clienteID',numCliente, 'ListaCreditoNoDes.htm');			
			}
		}
		
				
	}

	
	function valida(e,numeroFila){
		var jqControl = eval("'referencia" + numeroFila + "'");
		key=(document.all) ? e.keyCode : e.which;
		if (key < 48 || key > 57 || key == 46){
			if (key==8|| key == 46 || key == 0){
				return true;
		
			
		}
		else 
			mensajeSis("Sólo se pueden ingresar números");
  		$('#'+jqControl).focus();
  		$('#'+jqControl).val('');
		}
	}
	
	//Consulta y pone el monto sugerible de garantia liquida
	function consultaMontoGL(controlID,numeroFila){
		var jqCredito  = eval("'#" + controlID + "'");
		var creditoID = $(jqCredito).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		
		if($("#tiposBloqueoID"+numeroFila).val()== 8){ // el 8 corresponde a Garantia Liquida			
			if(creditoID != '' && !isNaN(creditoID)){
				var creditoBeanCon = { 
					'creditoID': creditoID
					};
	   			
	   				creditosServicio.consulta(12,creditoBeanCon,{ async: false, callback:function(credito) {
	   				if(credito!=null){
	   					evaluaEsAutomatico(creditoID, numeroFila);
	   					esTab=true;	

						$("#monto" + numeroFila).val(credito.montoGLSugerido);
						
					}
				}});
			}
		}

		if($("#tiposBloqueoID"+numeroFila).val()==20){ // el 20 corresponde a Garantia FOGAFI			
			if(creditoID != '' && !isNaN(creditoID)){
				var creditoBeanCon = { 
					'creditoID': creditoID
					};
	   			
	   				creditosServicio.consulta(41,creditoBeanCon,{ async: false, callback:function(credito) {
	   				if(credito!=null){
	   					evaluaEsAutomatico(creditoID, numeroFila);
	   					esTab=true;	

						$("#monto" + numeroFila).val(credito.montoGLSugerido);
						
					}
				}});
			}
		}
	}

//Consulta y pone el monto sugerible de garantia liquida
	function evaluaEsAutomatico(creditoID, numeroFila){
		var cuentaAhoBloqueo = $("#cuentaAho"+numeroFila).val();

		setTimeout("$('#cajaLista').hide();", 200);		
			if(creditoID != '' && !isNaN(creditoID)){
				var creditoBeanCon = { 
					'creditoID': creditoID
					};
	   			
	   			creditosServicio.consulta(1,creditoBeanCon,{ async: false, callback:function(credito) {
	   					if(credito.esAutomatico == 'S' && credito.tipoAutomatico == 'A'){
	   						cuentaAhorro = credito.cuentaAhoID;

	   						if(Number(cuentaAhoBloqueo) != cuentaAhorro){
								mensajeSis("La Cuenta no Coincide");
								deshabilitaBoton('agregar', 'submit');
	   						}
	   						else{
	   							habilitaBoton('agregar', 'submit');
	   						}
	   					}
	   					else{
	   						habilitaBoton('agregar', 'submit');
	   					}
	   						
				
				}});
			}
		
	}

	// Función que consulta si la Institución Cobra Garantía Financiada
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




