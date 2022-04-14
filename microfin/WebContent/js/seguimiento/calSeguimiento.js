var listaActividades = new Array();
//document.onmouseup = botonDerecho;
//function botonDerecho(e){
//	var msg = "cambiamos el click derecho";
//	if (navigator.appName == 'Netscape' && e.which == 3) {
//		alert(msg); 
//		return false;
//	}
//}

$(document).ready(function(){
});

jQuery.jcalendar = function() {
	var months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
	var days = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
	var navLinks = {p:'Anterior', n:'Siguiente', t:'Mes Actual'};
	var _firstDayOfWeek = 0;
	var _firstDate = new Date('1900-01-01');
	var _lastDate = new Date('1900-01-01');
	var _selectedDate = new Date('1900-01-01');
	
	var fechaSistema = parametroBean.fechaSucursal;
	var fechas = fechaSistema.replace(/-/, '');
	var fdia = fechas.substring(7,9);
	var mes = fechas.substring(5,6);
	var anio = fechas.substring(0,4);
	var fechaInicial = anio +"-" + mes + "-" + fdia;

	var _drawCalendar = function(dateIn, a, day, month, year) {
	  var today = new Date();
	  var d;

		if (dateIn == undefined) {
			// start from this month.
			d = new Date(today.getFullYear(), today.getMonth(), 1);
			year.val(today.getFullYear());
			month.val(today.getMonth()+1);
			day.val(today.getDate());
		}
		else {
			// start from the passed in date
			d = dateIn;
			d.setDate(1);
		}

		// check that date is within allowed limits
		if ((d.getMonth() < _firstDate.getMonth() && d.getFullYear() == _firstDate.getFullYear()) || d.getFullYear() < _firstDate.getFullYear()) {
//			alert(_firstDate);
			d = new Date(_firstDate.getFullYear(), _firstDate.getMonth(), 1);
		}
		else if ((d.getMonth() > _lastDate.getMonth() && d.getFullYear() == _lastDate.getFullYear()) || d.getFullYear() > _lastDate.getFullYear()) {
//			alert(_lastDate);
			d = new Date(_lastDate.getFullYear(), _lastDate.getMonth(), 1);
		}

		var firstMonth = true;
		var firstDate = _firstDate.getDate();

		// create prev and next links
		if (!(d.getMonth() == _firstDate.getMonth() && d.getFullYear() == _firstDate.getFullYear())) {
			// not in first display month so show a previous link
			firstMonth = false;
			var lastMonth = d.getMonth() == 0 ? new Date(d.getFullYear()-1, 11, 1) : new Date(d.getFullYear(), d.getMonth()-1, 1);
			var prevLink = jQuery('<a href="" class="link-prev">&lsaquo; '+ navLinks.p +'</a>').click(function() {
				jQuery.jcalendar.changeMonth(lastMonth, this, day, month, year);
				return false;
			});
		}

		var finalMonth = true;
		var lastDate = _lastDate.getDate();

		if (!(d.getMonth() == _lastDate.getMonth() && d.getFullYear() == _lastDate.getFullYear())) {
			// in the last month - no next link
			finalMonth = false;
			var nextMonth = new Date(d.getFullYear(), d.getMonth()+1, 1);
			var nextLink = jQuery('<a href="" class="link-next">'+ navLinks.n +' &rsaquo;</a>').click(function() {
				jQuery.jcalendar.changeMonth(nextMonth, this, day, month, year);
				return false;
			});
		}

		var todayLink = jQuery('<a href="" class="link-today">'+ navLinks.t +'</a>').click(function() {
			day.val(today.getDate());
			jQuery.jcalendar.changeMonth(today, this, day, month, year);
			return false;
		});

    // update the year and month select boxes
  	year.val(d.getFullYear());
  	month.val(d.getMonth()+1);

		var headRow = jQuery("<tr></tr>");
		for (var i=_firstDayOfWeek; i<_firstDayOfWeek+7; i++) {
			var weekday = i%7;
			var wordday = days[weekday];
			headRow.append('<th scope="col" abbr="'+ wordday +'" title="'+ wordday +'" class="'+ (weekday == 0 || weekday == 6 ? 'weekend' : 'weekday') +'">'+ wordday +'</th>');
		}
		headRow = jQuery("<thead></thead>").append(headRow);

		var tBody = jQuery("<tbody></tbody>");
		var lastDay = (new Date(d.getFullYear(), d.getMonth()+1, 0)).getDate();
		var curDay = _firstDayOfWeek - d.getDay();
		if (curDay > 0) curDay -= 7;

		var todayDate = today.getDate();
		var thisMonth = d.getMonth() == today.getMonth() && d.getFullYear() == today.getFullYear();

    // render calendar
		var parametros = consultaParametrosSession();
		var ultimoDiaMes = new Date( d.getFullYear(),d.getMonth()+1,0);
		
		var tipoLista = 3;
		var bean = {
				'fechaInicioSegto' : d.getFullYear()+'-'+Number(d.getMonth()+1)+'-01',
				'fechaFinalSegto' : ultimoDiaMes.getFullYear()+'-'+Number(ultimoDiaMes.getMonth()+1)+'-'+ultimoDiaMes.getDate(),
				'puestoResponsableID' : parametros.numeroUsuario
		};
		segtoManualServicio.lista(tipoLista, bean, function (data){
			if(data != null && data.length > 0){
				do {
			 		var thisRow = jQuery("<tr></tr>");
			  		for (var i=0; i<7; i++) {
			  			var weekday = (_firstDayOfWeek + i) % 7;
			  			var atts = {'class':(weekday == 0 || weekday == 6 ? 'weekend ' : 'weekday ')};

			  			if (curDay < 0 || curDay >= lastDay) {
			  				dayStr = ' ';
			  			}
			  			else if (firstMonth && curDay < firstDate-1) {
			  				dayStr = curDay+1;
			  				atts['class'] += 'inactive';
			  			}
			  			else if (finalMonth && curDay > lastDate-1) {
			  				dayStr = curDay+1;
			  				atts['class'] += 'inactive';
			  			}
			  			else {
			  				d.setDate(curDay+1);
			  				
			  				dayStr = jQuery('<a href="" rel="'+ d +'">'+ (curDay+1)+
			  						creaTablaDia(d, data)+
			  						+'</a>').click(function(e) {
								    if (_selectedDate) {
								       _selectedDate.removeClass('selected');
								    }
					      			_selectedDate = jQuery(this);
					      			_selectedDate.addClass('selected');
			            				day.val(new Date(_selectedDate.attr('rel')).getDate());
								var daten = new Date();
								daten.setFullYear(d.getFullYear());
								daten.setMonth(d.getMonth());
								daten.setDate(day.val());
								obteninfomuestra(daten);
			  					return false;
			  				});
			  				// highlight the current selected day
			  				if (day.val() == d.getDate()) {
			  				  _selectedDate = dayStr;
			  				  _selectedDate.addClass('selected');
			  				}
			  			
			  			}
			  			if (buscaDiaAct(d,data)) {
			  				atts['class'] += 'actividad';
			  			}
			  			else 
			  				if (thisMonth && curDay+1 == todayDate) {
			  				atts['class'] += 'today';
			  			}
			  			thisRow.append(jQuery("<td></td>").attr(atts).append(dayStr));
			  			curDay++;
			  		}

						tBody.append(thisRow);
					} while (curDay < lastDay);
					jQuery('div.jcalendar').html('<table cellspacing="1"></table><div class="jcalendar-links"></div>');
					jQuery('div.jcalendar table').append(headRow, tBody);
					jQuery('div.jcalendar > div.jcalendar-links').append(prevLink, todayLink, nextLink);
			}else{//aqui es cuando no hay lista de actividades del en el mes
				do {
			 		  var thisRow = jQuery("<tr></tr>");
			  		for (var i=0; i<7; i++) {
			  			var weekday = (_firstDayOfWeek + i) % 7;
			  			var atts = {'class':(weekday == 0 || weekday == 6 ? 'weekend ' : 'weekday ')};

			  			if (curDay < 0 || curDay >= lastDay) {
			  				dayStr = ' ';
			  			}
			  			else if (firstMonth && curDay < firstDate-1) {
			  				dayStr = curDay+1;
			  				atts['class'] += 'inactive';
			  			}
			  			else if (finalMonth && curDay > lastDate-1) {
			  				dayStr = curDay+1;
			  				atts['class'] += 'inactive';
			  			}
			  			else {
			  				d.setDate(curDay+1);
			  				dayStr = jQuery('<a href="" rel="'+ d +'">'+ (curDay+1)
			  						+'</a>').click(function(e) {
								    if (_selectedDate) {
								       _selectedDate.removeClass('selected');
								    }
					      			_selectedDate = jQuery(this);
					      			_selectedDate.addClass('selected');
			            				day.val(new Date(_selectedDate.attr('rel')).getDate());
							
			  					return false;
			  				});
			  				// highlight the current selected day
			  				if (day.val() == d.getDate()) {
			  				  _selectedDate = dayStr;
			  				  _selectedDate.addClass('selected');
			  				}
			  			
			  			}
			  				if (thisMonth && curDay+1 == todayDate) {
			  				atts['class'] += 'today';
			  			}
			  			thisRow.append(jQuery("<td></td>").attr(atts).append(dayStr));
			  			curDay++;
			      }
						tBody.append(thisRow);
					} while (curDay < lastDay);

					jQuery('div.jcalendar').html('<table cellspacing="1"></table><div class="jcalendar-links"></div>');
					jQuery('div.jcalendar table').append(headRow, tBody);
					jQuery('div.jcalendar > div.jcalendar-links').append(prevLink, todayLink, nextLink);
			}
		});
		

		
	};

	return {
		show: function(a, day, month, year) {
 			_firstDate = a._startDate;
			_lastDate = a._endDate;
			_firstDayOfWeek = a._firstDayOfWeek;

			// pass in the selected form date if one was set
			var selected;
			if (year.val() > 0 && month.val() > 0 && day.val() > 0) {
			  selected = new Date(year.val(), month.val()-1, day.val());
			}
			else {
			  selected = null;
			}
			_drawCalendar(selected, a, day, month, year);
		},
		changeMonth: function(d, e, day, month, year) {
			_drawCalendar(d, e, day, month, year);
		},
		setLanguageStrings: function(aDays, aMonths, aNavLinks) {
			days = aDays;
			months = aMonths;
			navLinks = aNavLinks;
		},
		
		setDateWindow: function(i, w, year) {
			if (w == undefined) w = {};
			if (w.startDate == undefined) {
				i._startDate = new Date($(year).find('option:eq(1)').val(), 0, 1);
			}
			else {
  			dateParts = w.startDate.split('-');
  			i._startDate = new Date(dateParts[2], Number(dateParts[1])-1, Number(dateParts[0]));
			}
			if (w.endDate == undefined) {
				i._endDate = new Date($(year).find('option:last').val(), 11, 1);
			}
			else {
  			dateParts = w.endDate.split('-');
  			i._endDate = new Date(dateParts[2], Number(dateParts[1])-1, Number(dateParts[0]));
			}
			i._firstDayOfWeek = w.firstDayOfWeek == undefined ? 0 : w.firstDayOfWeek;
		}
	};
}();


function creaTablaDia(date, lista){
	var arreglo = new Array();
	var mes = '01';
	var dia = '01';
	
	
	if(date.getMonth()<9){
		mes = '0'+Number(date.getMonth()+1);
	}else{
		mes = Number(date.getMonth()+1);
	}
	if(Number(date.getDate())<10){
		dia = '0'+date.getDate();
	}else{
		dia = date.getDate();
	}
	
	
	var fechaActual = date.getFullYear()+"-"+mes+"-"+dia;
	for(var i = 0; i < lista.length ; i++){
		if(isNaN(arreglo[lista[i].categoriaID])||arreglo[lista[i].categoriaID] == undefined){
			arreglo[lista[i].categoriaID] = 0;
		}
		if(lista[i].fechaProgramada == fechaActual){
			arreglo[lista[i].categoriaID]++;
		}
	}

	
	var primerCuadro = new Array();
	var segundoCuadro = new Array();
	var tercerCuadro = new Array();
	var cuartoCuadro = new Array();

	primerCuadro[0] = 0;
	primerCuadro[1] = 0;
	for(var i = 0; i < arreglo.length; i++){
		if(arreglo[i]>primerCuadro[0]){
			primerCuadro[0] = arreglo[i];
			primerCuadro[1] = i;
		}
	}
	
	segundoCuadro[0] = 0;
	segundoCuadro[1] = 0;
	for(var i = 0; i < arreglo.length; i++){
		if(primerCuadro[1] != i && 													arreglo[i]>=segundoCuadro[0]){
			segundoCuadro[0] = arreglo[i];
			segundoCuadro[1] = i;
		}
	}
	
	tercerCuadro[0] = 0;
	tercerCuadro[1] = 0;
	for(var i = 0; i < arreglo.length; i++){
		if(primerCuadro[1] != i && segundoCuadro[1] != i && 						arreglo[i]>=tercerCuadro[0]){
			tercerCuadro[0] = arreglo[i];
			tercerCuadro[1] = i;
		}
	}

	cuartoCuadro[0] = 0;
	cuartoCuadro[1] = 0;
	for(var i = 0; i < arreglo.length; i++){
		if(primerCuadro[1] != i && segundoCuadro[1] != i && tercerCuadro[1] != i && arreglo[i]>=cuartoCuadro[0]){
			cuartoCuadro[0] = arreglo[i];
			cuartoCuadro[1] = i;
		}
	}
	
	
	var cadenaRespuesta = '<table><tr>';
	if(primerCuadro[0]>0){
		cadenaRespuesta = cadenaRespuesta+'<td class="color'+primerCuadro[1]+'">'+primerCuadro[0]+'</td>';
		if(segundoCuadro[0]>0){
			cadenaRespuesta = cadenaRespuesta+'<td class="color'+segundoCuadro[1]+'">'+segundoCuadro[0]+'</td>';
			if(tercerCuadro[0]>0){
				cadenaRespuesta = cadenaRespuesta+'</tr><tr><td class="color'+tercerCuadro[1]+'">'+tercerCuadro[0]+'</td>';
				if(cuartoCuadro[0]>0){
					cadenaRespuesta = cadenaRespuesta+'<td class="color'+cuartoCuadro[1]+'">'+cuartoCuadro[0]+'</td>'; 
				}
			}
		}
	}
	cadenaRespuesta =cadenaRespuesta+ "</tr></table>";
	
	return cadenaRespuesta;
}


function buscaDiaAct(date, Arr){
	
	var retorno = false;
	if(Arr.length <= 0 || Arr.length==null || Arr.length == undefined ){
		return retorno;
	}
	var mes = '01';
	var dia = '01';
	if(date.getMonth()<9){
		mes = '0'+Number(date.getMonth()+1);
	}else{
		mes = Number(date.getMonth()+1);
	}
	if(Number(date.getDate())<10){
		dia = '0'+date.getDate();
	}else{
		dia = date.getDate();
	}
	var fechaActual = date.getFullYear()+"-"+mes+"-"+dia;
	
	for(var i = 0;i < Arr.length; i++){
		if(fechaActual == Arr[i].fechaProgramada){
			retorno = true;
		}
	}
	return retorno;
}


function obteninfomuestra(date){
	
	var parametros = consultaParametrosSession();
	var params = {};
	params['tipoLista'] = 1;
	params['fechaProgramada'] = date.getFullYear()+'-'+Number(date.getMonth()+1)+'-'+date.getDate();
	params['puestoResponsableID'] = parametros.numeroUsuario;
	$('#listaDetalle').html('');
	$.post("listaCalSegto.htm", params, function(data){
		if(data.length>0){
		$('#listaPrev').html(data);
		}else{
		alert('No data recibed from server');
		$('#listaPrev').html('');
		}
	});
}

function detalleLista(idcontrol){
	$('#consultaID').val(idcontrol);
	$('#listaDetalle').load("capturaSegtoRealizado.htm");
}
jQuery.fn.jcalendar = function(a) {
	this.each(function() {
    var day = $(this).find('select.jcalendar-select-day');
    var month = $(this).find('select.jcalendar-select-month');
    var year = $(this).find('select.jcalendar-select-year');
    $('div.jcalendar-selects').after('<div class="jcalendar"></div>');
		jQuery.jcalendar.setDateWindow(this, a, year);
		jQuery.jcalendar.show(this, day, month, year);

		day.change(function() {
		  // only if a valid day is selected
		  if (this.value > 0) {
		    d = new Date(year.val(), month.val()-1, this.value);
  	    jQuery.jcalendar.changeMonth(d, a, day, month, year);
  	  }
		});

		month.change(function() {
		  // only if a valid month is selected
		  if (this.value > 0) {
		    d = new Date(year.val(), this.value-1, 1);
  	    jQuery.jcalendar.changeMonth(d, a, day, month, year);
  	  }
		});

		year.change(function() {
		  // only if a valid year is selected
		  if (this.value > 0) {
  		  d = new Date(this.value, month.val()-1, 1);
    	  jQuery.jcalendar.changeMonth(d, a, day, month, year);
    	}
		});

	});
	return this;
};