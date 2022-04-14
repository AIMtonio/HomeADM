var esTab;

$(document).ready(function() {
	var consultoPuestos=true;
	var catTipoConsultaPuestos = {
			'principal' : 1

	}; 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionProspec = {
			'agrega':'1',
			'modifica':'2', 
	}; 

	var catTipoConsultaProspec = {
			'principal':1,
			'foranea':2
	};	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});


	// var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('grabar', 'submit');
	consultaproductosCre();
	agregaEtiquetasTabla();
	consultaproductosCreAplica();
	$('#divPuestos').hide();


	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionConGrid(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','prospectoID');
			deshabilitaBoton('grabar', 'submit');
		}
	});		

	$('select').css('background-color','#FFFFFF');

	$('#agregar').click(function() {
		if(verificarVacios()){
			if($('#producCreditoID').val() != ''){
				if($('#numeroDetalle').val()=='0'){
					$('#divPuestos').show('slow');
					habilitaBoton('grabar', 'submit');
					consultoPuestos=true;
				}
				var opcionSelec = $('#producCreditoID').val();
				if(consultoPuestos==true){
					pegaHtml(opcionSelec,false);
					$('#divPuestos').show();
					consultoPuestos=false;
				}
				agregaNuevoDetalle();
			}else{
				mensajeSis('Seleccione un Producto de Crédito');
			}
		}
	});

	$('#grabar').click(function() {	

		if(validaMontosGrid()!=0){
			return false;
		}else{
			$('#tipoTransaccion').val(1);
		}
	});

	$('#productosAplica').change(function() {
		var todos="1";
		var opcionSelec = $('#productosAplica').val();
		if(opcionSelec==todos){
			seleccionaTodosProd();
		}   

	});

	$('#producCreditoID').change(function() {
		limpiaFormaGridPantalla();
		consultoPuestos=true;
	});


	$('#consultar').click(function() {
		if($('#producCreditoID').val() != '' ){
			var opcionSelec = $('#producCreditoID').val();
			habilitaBoton('grabar', 'submit');
			pegaHtml(opcionSelec,true);
			$('#divPuestos').show();
		}else{
			mensajeSis('Seleccione Un Producto de Crédito');
		}

	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		// quitaFormatoControles('formaGenerica');
		rules: {


			primerNombre: { 
				required: true
			},	
			apellidoPaterno: { 
				required: true
			}
		},
		messages: {
			primerNombre: {
				required: 'Especificar Nombre'
			},
			apellidoPaterno: {
				required: 'Especificar Apellido'
			}
		}		
	});

	function consultaproductosCre(){
		var tipoCon=10;
		dwr.util.removeAllOptions('producCreditoID');
		dwr.util.addOptions( 'producCreditoID', {'':'SELECCIONE'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('producCreditoID', productos, 'producCreditoID', 'descripcion');
		});
	}
   
	function consultaproductosCreAplica(){
		var tipoCon=10;
		dwr.util.removeAllOptions('productosAplica');
		dwr.util.addOptions( 'productosAplica', {'':'SELECCIONE'});
		dwr.util.addOptions( 'productosAplica', {'1':'TODOS'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('productosAplica', productos, 'producCreditoID', 'descripcion');
		});
	}

	function consultaProdCreAplica(){
		var tipolistaProdAplica=3;
		var numeroTrans = 0;
		var prodCrePrinpal = $('#producCreditoID').val();
		var existenMasProd=false;
		$('input[name=numTransaccion]').each(function() {	
			var jqnumTransaccion =  eval("'#"+ this.id +"'");  
			numeroTrans = $(jqnumTransaccion).asNumber();
		});

		if(numeroTrans!=0){
			var creLimiteQuitasBean = {
					'numTransaccion': numeroTrans
			};
			creLimiteQuitasServicio.lista(tipolistaProdAplica, creLimiteQuitasBean, function(data){
				if(data!=null){
					for(var i=0;i<data.length;i++){
							var jqOpcion = eval("'#productosAplica option[value="+ data[i].producCreditoID +"]'");   
							$(jqOpcion).attr("selected","selected");
							existenMasProd=true;
					}
					if(existenMasProd){
						$('#productosAplica').focus();
					}
				}
			});
		}

	}

	function inicializaComboProdAplica(){
		
	 $("#productosAplica option").each(function(){

			idProducto = $(this).attr('value');
			var jqOpcion = eval("'#productosAplica option[value="+ idProducto +"]'");  
			 
				$(jqOpcion).removeAttr("selected");   
			 
		});  
	}
	
	function seleccionaTodosProd() {

		$("#productosAplica option").each(function(){

			idProducto = $(this).attr('value');
			var jqOpcion = eval("'#productosAplica option[value="+ idProducto +"]'");  
			if (idProducto!="1" && idProducto!=""){
				$(jqOpcion).attr("selected","selected");   
			}
		});  
	}  


	function pegaHtml(prodCreID, validaVacio){

		if(!isNaN(prodCreID)){
			var params = {};	
			var conPrincipal=1;
			params['producCreditoID'] = prodCreID;
			params['tipoConsulta'] =  conPrincipal;

			$.post("limQuitasGridDetallesAgro.htm", params, function(data){
				if(data.length >0 ){
					$('#divPuestos').replaceWith(data); 
					corrigeNumeroDetalle('numeroDetalle');
					if($('#numeroDetalle').val()=='0' && validaVacio==true){
						deshabilitaBoton('grabar', 'submit');
						mensajeSis('No se han encontrado Detalles.');
					}
					inicializaComboProdAplica();//quita propiedad selected al select
					consultaDecPuestos();//consulta la descripcion de los puestos
					agregaFormatoGridMontos();//agrega el formato moneda a cada monto
					consultaProdCreAplica();//consulta los productos en que aplica
					if(!validaVacio){
						agregaNuevoDetalle();
					}
				}else{
					mensajeSis('No se han encontrado movimientos con los datos proporcionados');

				}
			}); 
		}		 
	}

	function consultaDecPuestos(){
		$('input[name=elimina]').each(function() {		
			validaPuestosGrid(this.id );
		});

	}

	function corrigeNumeroDetalle(idControl){
		var jqNumeroDetalle = eval("'#" + idControl + "'");
		var numero = $(jqNumeroDetalle).val();
		if(isNaN(numero) || numero==''){
			$(jqNumeroDetalle).val('0');
		}
	}

	function validaPuestosGrid(numeroLista ) {
		var jqClavePuesto =  eval("'#clavePuestoID" + numeroLista + "'");
		var jqDescrip = eval("'#descriPuesto" + numeroLista + "'");
		var conPrincipal =1 ;

		var clavePuestoID=$(jqClavePuesto).val();

		setTimeout("$('#cajaLista').hide();", 200);

		var puestosBeanCon = { 
				'clavePuestoID':clavePuestoID		  				
		};

		if(clavePuestoID != ''  ){
			puestosServicio.consulta(conPrincipal ,puestosBeanCon,function(puestos) {
				if(puestos!=null){

					$(jqDescrip).val(puestos.descripcion);

				}
				else{

				}
			});
		}
	}

	function validaMontosGrid(){

		var existeError = 0;
		$('input[name=elimina]').each(function() {		
			// asignacion de campos
			var jqClavePuestoID = eval("'#clavePuestoID" + this.id + "'");

			var jqlimMontoCap = eval("'#limMontoCap" + this.id + "'");
			var jqlimPorcenCap =  eval("'#limPorcenCap" + this.id + "'");

			var jqlimMontoIntere =  eval("'#limMontoIntere" + this.id + "'");
			var jqlimPorcenIntere =  eval("'#limPorcenIntere" + this.id + "'");

			var jqlimMontoMorato =  eval("'#limMontoMorato" + this.id + "'");
			var jqlimPorcenMorato =  eval("'#limPorcenMorato" + this.id + "'");

			var jqlimMontoAccesorios =  eval("'#limMontoAccesorios" + this.id + "'");
			var jqlimPorcenAccesorios =  eval("'#limPorcenAccesorios" + this.id + "'");

			var jqNumMaxCondona =  eval("'#limPorcenAccesorios" + this.id + "'");

			//asignacion de valores
			var cvePsto = $(jqClavePuestoID).val();
			var clavePuestoID = $.trim(cvePsto);

			var limMontoCap = $(jqlimMontoCap).asNumber();
			if(limMontoCap==0)$(jqlimMontoCap).val('0.00');
			var limPorcenCap =  $(jqlimPorcenCap).asNumber();
			if(limPorcenCap==0)$(jqlimPorcenCap).val('0.00');

			var limMontoIntere =  $(jqlimMontoIntere).asNumber();
			if(limMontoIntere==0)$(jqlimMontoIntere).val('0.00');
			var limPorcenIntere =   $(jqlimPorcenIntere).asNumber();
			if(limPorcenIntere==0)$(jqlimPorcenIntere).val('0.00');

			var limMontoMorato =  $(jqlimMontoMorato).asNumber();
			if(limMontoMorato==0)$(jqlimMontoMorato).val('0.00');
			var limPorcenMorato =   $(jqlimPorcenMorato).asNumber();
			if(limPorcenMorato==0)$(jqlimPorcenMorato).val('0.00');

			var limMontoAccesorios =  $(jqlimMontoAccesorios).asNumber();
			if(limMontoAccesorios==0)$(jqlimMontoAccesorios).val('0.00');
			var limPorcenAccesorios =  $(jqlimPorcenAccesorios).asNumber();
			if(limPorcenAccesorios==0)$(jqlimPorcenAccesorios).val('0.00');

			var  numMaxCondona =  $(jqNumMaxCondona).asNumber();
			if(numMaxCondona==0)$(jqNumMaxCondona).val('0');

			if(existeError==0){
				if(clavePuestoID==''){
					mensajeSis("La clave del puesto está vacía.");
					$(jqClavePuestoID).focus();
					existeError=1;
					return;
				}	
			}		

			// monto cap
			if(existeError==0){
				if(limMontoCap>0 && limPorcenCap<=0 ){
					mensajeSis("El Porcentaje no puede ser igual a cero si existe un Monto mayor a cero.")
					$(jqlimPorcenCap).focus();
					existeError=1;
					return;
				}
			}

			if(existeError==0){
				if(limMontoCap==0 && limPorcenCap>0 ){
					mensajeSis("El Monto no puede ser igual a cero si existe un Porcentaje mayor a cero.")
					$(jqlimMontoCap).focus();
					existeError=1;
					return;
				}
			}

			if(existeError==0){
				if(limPorcenCap>100 ){
					mensajeSis("El Porcentaje no puede ser mayor a 100%.")
					$(jqlimPorcenCap).focus();
					existeError=1;
					return;
				}
			}

			//monto interes

			if(existeError==0){
				if(limMontoIntere>0 && limPorcenIntere<=0 ){
					mensajeSis("El Porcentaje no puede ser igual a cero si existe un Monto mayor a cero.")
					$(jqlimPorcenIntere).focus();
					existeError=1;
					return;
				}
			}

			if(existeError==0){
				if(limMontoIntere==0 && limPorcenIntere>0 ){
					mensajeSis("El Monto no puede ser igual a cero si existe un Porcentaje mayor a cero.")
					$(jqlimMontoIntere).focus();
					existeError=1;
					return;
				}
			}

			if(existeError==0){
				if(limPorcenIntere>100 ){
					mensajeSis("El Porcentaje no puede ser mayor a 100%.")
					$(jqlimPorcenIntere).focus();
					existeError=1;
					return;
				}
			}

			//Monto Moratorio

			if(existeError==0){
				if(limMontoMorato>0 && limPorcenMorato<=0 ){
					mensajeSis("El Porcentaje no puede ser igual a cero si existe un Monto mayor a cero.")
					$(jqlimPorcenMorato).focus();
					existeError=1;
					return;
				}
			}

			if(existeError==0){
				if(limMontoMorato==0 && limPorcenMorato>0 ){
					mensajeSis("El Monto no puede ser igual a cero si existe un Porcentaje mayor a cero.")
					$(jqlimMontoMorato).focus();
					existeError=1;
					return;
				}
			}

			if(existeError==0){
				if(limPorcenMorato>100 ){
					mensajeSis("El Porcentaje no puede ser mayor a 100%.")
					$(jqlimPorcenMorato).focus();
					existeError=1;
					return;
				}
			}

			//Monto Accesorios


			if(existeError==0){
				if(limMontoAccesorios>0 && limPorcenAccesorios<=0 ){
					mensajeSis("El Porcentaje no puede ser igual a cero si existe un Monto mayor a cero.")
					$(jqlimPorcenAccesorios).focus();
					existeError=1;
					return;
				}
			}

			if(existeError==0){
				if(limMontoAccesorios==0 && limPorcenAccesorios>0 ){
					mensajeSis("El Monto no puede ser igual a cero si existe un Porcentaje mayor a cero.")
					$(jqlimMontoAccesorios).focus();
					existeError=1;
					return;
				}
			}

			if(existeError==0){
				if(limPorcenAccesorios>100 ){
					mensajeSis("El Porcentaje no puede ser mayor a 100%.")
					$(jqlimPorcenAccesorios).focus();
					existeError=1;
					return;
				}
			}
		});

		return existeError;
	}

	function agregaFormatoGridMontos(){

		$('input[name=elimina]').each(function() {		

			agregaFormato('limMontoCap'+this.id);
			agregaFormatoPorcentaje('limPorcenCap'+this.id);
			agregaFormato('limMontoIntere'+this.id);
			agregaFormatoPorcentaje('limPorcenIntere'+this.id);

			agregaFormato('limMontoMorato'+this.id);
			agregaFormatoPorcentaje('limPorcenMorato'+this.id);
			agregaFormato('limMontoAccesorios'+this.id);
			agregaFormatoPorcentaje('limPorcenAccesorios'+this.id);

		});
	}

});	//  F I N    D E     D O C U M E N T   R E A D Y 


//INICION DE FUNCIONES DEL GRID

function agregaNuevoDetalle(){
	if(verificarVacios()){
	
		var numeroFila = $('#numeroDetalle').val();
		var nuevaFila = parseInt(numeroFila) + 1;		

		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';

		tds +=' <td><input type="text" id="clavePuestoID'+nuevaFila+'" 	 	name="clavePuestoIDLis" onkeyup="muestralistaPuestos(\'clavePuestoID'+nuevaFila+'\')" onblur="validaPuestos(\'clavePuestoID'+nuevaFila+'\',\'descriPuesto'+nuevaFila+'\' )" size="12" value="" maxlength="12"/> ';  
		tds +='  <input type="text" id="descriPuesto'+nuevaFila+'"			name="descriPuesto" disabled="true"  size="35"  value=""/> </td>';  

		tds +=' <td><input type="text" id="limMontoCap'+nuevaFila+'" 		name="limMontoCapLis" esMoneda="true" onkeypress="return Validador(event,  this);" style="text-align:right;"  path="limMontoCap" size="12" value="" maxlength="12" /> </td>';  
		tds +=' <td><input type="text" id="limPorcenCap'+nuevaFila+'" 		name="limPorcenCapLis" onBlur="validaPorcentaje(this);" onkeypress="return Validador(event,  this);" style="text-align:right;"   path="limPorcenCap" size="7"  value="" maxlength="7"/> </td>';  

		tds +=' <td><input type="text" id="limMontoIntere'+nuevaFila+'" 	name="limMontoIntereLis"  esMoneda="true" onkeypress="return Validador(event,  this);" style="text-align:right;"   path="limMontoIntere"  size="12" value="" maxlength="12"/> </td>';  
		tds +=' <td><input type="text" id="limPorcenIntere'+nuevaFila+'" 	name="limPorcenIntereLis"  onBlur="validaPorcentaje(this);" onkeypress="return Validador(event,  this);" style="text-align:right;"  path="limPorcenIntere" size="7"   value="" maxlength="7"/> </td>';  

		tds +=' <td><input type="text" id="limMontoMorato'+nuevaFila+'" 	name="limMontoMoratoLis"  esMoneda="true" onkeypress="return Validador(event,  this);" style="text-align:right;"  path="limMontoMorato"  size="12" value="" maxlength="12"/> </td>';  
		tds +=' <td><input type="text" id="limPorcenMorato'+nuevaFila+'"	name="limPorcenMoratoLis"  onBlur="validaPorcentaje(this);" onkeypress="return Validador(event,  this);" style="text-align:right;"  path="limPorcenMorato" size="7"  value="" maxlength="7"/> </td>';  			 

		tds +=' <td><input type="text" id="limMontoAccesorios'+nuevaFila+'" name="limMontoAccesoriosLis"  esMoneda="true" onkeypress="return Validador(event,  this);" style="text-align:right;"  path="limMontoAccesorios"  size="12" value="" maxlength="12" /> </td>';  
		tds +=' <td><input type="text" id="limPorcenAccesorios'+nuevaFila+'" name="limPorcenAccesoriosLis"  onBlur="validaPorcentaje(this);" onkeypress="return Validador(event,  this);" style="text-align:right;"  path="limPorcenAccesorios"  size="7" value="" maxlength="7" /> </td>';  		 

		tds +=' <td><input type="text" id="numMaxCondona'+nuevaFila+'" 		name="numMaxCondonaLis" onkeypress="return Validador(event,  this);" style="text-align:right;"  path="numMaxCondona"  size="7" value="" maxlength="7"/> </td>';  		 


		tds += '<td align="center">	<input type="button" name="elimina" id="'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalle('+nuevaFila +')"/>';
		tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
		tds += '</tr>';

		document.getElementById("numeroDetalle").value = nuevaFila;    	
		$("#miTabla").append(tds);

		agregaFormato('limMontoCap'+nuevaFila);
		agregaFormatoPorcentaje('limPorcenCap'+nuevaFila);
		agregaFormato('limMontoIntere'+nuevaFila);
		agregaFormatoPorcentaje('limPorcenIntere'+nuevaFila);

		agregaFormato('limMontoMorato'+nuevaFila);
		agregaFormatoPorcentaje('limPorcenMorato'+nuevaFila);
		agregaFormato('limMontoAccesorios'+nuevaFila);
		agregaFormatoPorcentaje('limPorcenAccesorios'+nuevaFila);
		
	}
}	

function validaPorcentaje(control){
	var jControl = eval("'#" + control.id + "'"); 
	var porcentaje = $(jControl).asNumber();
	if(porcentaje>100){
		mensajeSis("El porcentaje no debe exceder de 100 %");
		$(jControl).val("");
		$(jControl).focus();
	}
	
}


function agregaFormato(idControl){
	var jControl = eval("'#" + idControl + "'"); 

	$(jControl).bind('keyup',function(){
		$(jControl).formatCurrency({
			colorize: true,
			positiveFormat: '%n', 
			negativeFormat: '%n',
			roundToDecimalPlace: -1
		});
	});
	$(jControl).blur(function() {
		$(jControl).formatCurrency({
			positiveFormat: '%n', 
			negativeFormat: '%n',
			roundToDecimalPlace: 2	
		});
	});
	$(jControl).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});			
}

function agregaFormatoPorcentaje(idControl){
	var jControl = eval("'#" + idControl + "'"); 

	$(jControl).bind('keyup',function(){
		$(jControl).formatCurrency({
			colorize: true,
			positiveFormat: '%n', 
			negativeFormat: '%n',
			roundToDecimalPlace: -1
		});
	});
	$(jControl).blur(function() {
		$(jControl).formatCurrency({
			positiveFormat: '%n', 
			negativeFormat: '%n',
			roundToDecimalPlace: 2
		});
	});
	$(jControl).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2
	});			
}


function agregaEtiquetasTabla(){

	var tds = '<tr>';

	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">Puesto</label>  </td>';  

	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">Capital <br> Monto</label>  </td>';  
	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">%</label>  </td>';  

	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">Interés <br> Monto</label>  </td>';  
	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">%</label>  </td>';  

	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">Moratorios <br> Monto</label>  </td>';  
	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">%</label>  </td>';  	 

	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">Accesorios <br> Monto</label>  </td>';  
	tds +=' <td  class="label"> <label for="lblnumCtaAhorro">%</label>  </td>';    		 

	tds +=' <td  class="label"> <label for="lblnumCtaAhorro"># Cond. por  <br> Crédito</label>  </td>';  		 

	tds += '</tr>';


	$("#miTabla").append(tds);

}	


function eliminaDetalle(numeroID){		

	var jqTr = eval("'#renglon" + numeroID + "'");


	var jqClavePuestoID = eval("'#clavePuestoID" + numeroID + "'");
	var jqLimMontoCap	 = eval("'#limMontoCap" + numeroID + "'");
	var jqLimPorcenCap	= eval("'#limPorcenCap" + numeroID + "'");
	var jqLimMontoIntere	  = eval("'#limMontoIntere" + numeroID + "'");
	var jqLimPorcenIntere	 = eval("'#limPorcenIntere" + numeroID + "'");
	var jqLimMontoMorato	 = eval("'#limMontoMorato" + numeroID + "'");
	var jqLimPorcenMorato	 = eval("'#limPorcenMorato" + numeroID + "'");
	var jqLimMontoAccesorios	 = eval("'#limMontoAccesorios" + numeroID + "'");
	var jqLimPorcenAccesorios	  = eval("'#limPorcenAccesorios" + numeroID + "'");
	var jqNumMaxCondona  = eval("'#numMaxCondona" + numeroID + "'");

	var jqElimina = eval("'#" + numeroID + "'");
	var jqAgrega = eval("'#agrega" + numeroID + "'");

	$(jqClavePuestoID).remove(); 
	$(jqLimMontoCap).remove();	 
	$(jqLimPorcenCap).remove();	 
	$(jqLimMontoIntere).remove(); 
	$(jqLimPorcenIntere).remove();	 
	$(jqLimMontoMorato).remove();	  
	$(jqLimPorcenMorato).remove(); 
	$(jqLimMontoAccesorios).remove();
	$(jqLimPorcenAccesorios).remove();	   
	$(jqNumMaxCondona).remove();  

	$(jqElimina).remove();
	$(jqAgrega).remove();

	$(jqTr).remove();


	var existenGrids = false;
	$('input[name=elimina]').each(function() {		
		var jqConsecutivo = eval("'#" + this.id + "'");	
		existenGrids = true;
	});

	if(existenGrids==false) {
		$('#numeroDetalle').val(0);
		consultoPuestos=true;
		$('#divPuestos').hide('slow');
	}

}


function validaPuestos(control,descripcion ) {
	
	var jqClavePuesto =  eval("'#" + control + "'");
	var jqDescrip = eval("'#" + descripcion + "'");
	var conPrincipal =1 ;

	var clavePuestoID=$(jqClavePuesto).val();

	var puestosBeanCon = { 
			'clavePuestoID':clavePuestoID		  				
	};

	setTimeout("$('#cajaLista').hide();", 200);
	$(jqClavePuesto).val(clavePuestoID.toUpperCase());

	consultaPuestos(control);

	var Clave=clavePuestoID.replace(/[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/gi,'');

		if(Clave != ''){// consulta 	
			puestosServicio.consulta(conPrincipal ,puestosBeanCon,function(puestos) {
				if(puestos != null){
					$(jqDescrip).val(puestos.descripcion);
				}else{
					mensajeSis("No se ha encontrado el puesto.");
					$(jqClavePuesto).val("");
					$(jqDescrip).val("");
				}
			});
		}else{
			$(jqClavePuesto).val("");
			$(jqDescrip).val("");
			$(jqClavePuesto).focus("");
		}
}

function Validador(e,  elemento) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {
		if (key==8 || key == 46 || key == 0)	{ 
			return true;
		}
		else
			mensajeSis("Sólo números");
		return false;
	} 
}

function muestralistaPuestos(control){

	var jqClavePuesto =  eval("'#" + control+ "'");
	var camposLista = new Array();
	var parametrosLista = new Array(); 
	camposLista[0] = "descripcion";
	parametrosLista[0] = $(jqClavePuesto).val();

	listaAlfanumerica( control, '1', '1', camposLista, parametrosLista, 'listaPuestos.htm'); 
}


function limpiaFormaGridPantalla(){

	$('input[name=elimina]').each(function() {	

		eliminaDetalle(this.id);

	});
	 $("#productosAplica option").each(function(){

		idProducto = $(this).attr('value');
		var jqOpcion = eval("'#productosAplica option[value="+ idProducto +"]'");  
		$(jqOpcion).removeAttr("selected");   
			 
	});  

}
//FUNCION QUE VERIFICA QUE LOS CAMPOS NO ESTEN VACIOS
function verificarVacios(){	
	var exito = true;	
	var numRenglones = consultaFilas();	
	
	for(var i = 1; i <= numRenglones; i++){
		var clavePuestoID = eval("'#clavePuestoID" + i + "'");
		
		var limMontoCap = eval("'#limMontoCap" + i + "'");
		var limPorcenCap = eval("'#limPorcenCap" + i + "'");
		
		var limMontoIntere = eval("'#limMontoIntere" + i + "'");
		var limPorcenIntere = eval("'#limPorcenIntere" + i + "'");
		
		var limMontoMorato = eval("'#limMontoMorato" + i + "'");
		var limPorcenMorato = eval("'#limPorcenMorato" + i + "'");
		
		var limMontoAccesorios = eval("'#limMontoAccesorios" + i + "'");
		var limPorcenAccesorios = eval("'#limPorcenAccesorios" + i + "'");
		
		var numMaxCondona = eval("'#numMaxCondona" + i + "'");
		
				
		if($(clavePuestoID).val() == ''){
			$(clavePuestoID).focus();
			exito = false;
			mensajeSis('Especificar Clave de Puesto');
			break;
		}
		
		if($(limMontoCap).val() == ''){
			$(limMontoCap).focus();
			exito = false;
			mensajeSis('Especificar Limite Monto Capital');
			break;
		}
		if($(limPorcenCap).val() == ''){
			$(limPorcenCap).focus();
			exito = false;
			mensajeSis('Especificar Limite Porcentaje Capital');
			break;
		}	
		
		if($(limMontoIntere).val() == ''){
			$(limMontoIntere).focus();
			exito = false;
			mensajeSis('Especificar Limite Monto Interés');
			break;
		}
		if($(limPorcenIntere).val() == ''){
			$(limPorcenIntere).focus();
			exito = false;
			mensajeSis('Especificar Limite Porcentaje Interés');
			break;
		}	
		
		if($(limMontoMorato).val() == ''){
			$(limMontoMorato).focus();
			exito = false;
			mensajeSis('Especificar Limite Monto Moratorio');
			break;
		}
		if($(limPorcenMorato).val() == ''){
			$(limPorcenMorato).focus();
			exito = false;
			mensajeSis('Especificar Limite Porcentaje Moratorio');
			break;
		}	

		if($(limMontoAccesorios).val() == ''){
			$(limMontoAccesorios).focus();
			exito = false;
			mensajeSis('Especificar Limite Monto Accesorios');
			break;
		}
		if($(limPorcenAccesorios).val() == ''){
			$(limPorcenAccesorios).focus();
			exito = false;
			mensajeSis('Especificar Limite Porcentaje Accesorios');
			break;
		}	
			
		if($(numMaxCondona).val() == ''){
			$(numMaxCondona).focus();
			exito = false;
			mensajeSis('Especificar Num. Max. de Condonaciones');
			break;
		}
		
		
	}
	return exito;
		
}

function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
}	

function consultaPuestos(idCampo){
	
	var jqNumeroDetalle = eval("'#" + idCampo + "'");
	var nuevoPuesto = $(jqNumeroDetalle).val();
	nuevoPuesto = nuevoPuesto.toUpperCase();


	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdPuestos = eval("'clavePuestoID" + numero+ "'");
		var valorPuestos=$('#'+jqIdPuestos).val();
		valorPuestos = valorPuestos.toUpperCase();
		var numDes = idCampo.substr(13,idCampo.length);
		var descripPuesto = eval("'#" + "descriPuesto" + numDes +"'");

			if((jqIdPuestos) != idCampo){
				if(valorPuestos == nuevoPuesto){
					mensajeSis("El Puesto se Repite Para el Producto de Crédito Indicado ");
					$('#'+idCampo).focus();
					$('#'+idCampo).val("");
					$(descripPuesto).val("");
				}
			}
	});
}

