package fira.bean;

import general.bean.BaseBean;

import java.util.List;

public class GarantiaAgroBean extends BaseBean {
	//Datos generales
		private String  garantiaID;
		private String 	prospectoID;
		private String 	clienteID;
		private String 	avalID;
		private String 	garanteID;
		private String  garanteNombre;
		private String 	tipoGarantiaID;
		private String 	clasifGarantiaID;
		private String 	clasifGarantiaDesc;
		private String 	valorComercial;
		private String 	observaciones;
		private String  tipoDocumentoID;
		private String  montoAvaluo;
		
		//Propietario de la garantia
		private String  propietario;//C=cliente, P=Prospecto,O=Otros
		private String  nombrePropUno;// si(propietario=Otros)
		private String  nombrePropDos;// si(propietario=Otros)
		private String  clienteIDProp;
		private String  prospectoIDProp;
		
		// UBICACIONES
		private String 	estadoID;
		private String 	municipioID;
		private String 	calle;
		private String 	numero;
		private String 	numeroInt;
		private String 	lote;
		private String 	manzana;
		private String 	colonia;
		private String 	codigoPostal;
		private String 	m2Construccion;
		private String 	m2Terreno;
		private String 	asegurado;
		private String 	asegurador;
		private String 	numPoliza;
		private String 	vencimientoPoliza;
		private String 	folioRegistro;
		private String  fechaRegistro;
			//ACTA DE POSESION
			private String 	nombreAutoridad;
			private String 	cargoAutoridad;
			
			//TESTIMONIO NOTARIAL
			private String 	notarioID;
			
		//FACTURA
		private String 	 fechaCompFactura;
		private String 	rfcEmisor;
		private String 	valorFactura;
		private String 	serieFactura;
		private String 	referenciafact;

	 // valuacion
		private String 	fechaValuacion;
		private String 	numAvaluo;
		private String 	nombreValuador;
		private String 	verificada;
		private String 	fechaVerificacion;
		private String 	tipoGravemen;
		private String 	fechagravemen;
		private String 	montoGravemen;
		private String 	nombBenefiGrav;

		private String 	tipoInsCaptacion;
		private String 	insCaptacionID;
		private String 	montoAsignado;
		private String 	estatus;
		private String  requiereGarantia;//para  Consulta
		private String noIdentificacion;

		
		/// ASIGNACION DE GARANTIAS
		private String solicitudCreditoID;
		private String creditoID;
		private List lgarantiaID;
		private List lmontoAsignado;
		// fin
		private String numIdentificacion;
		private String relGarantCred;
		private String sucursalID;
		
		// INICIO DE GETTERS Y SETTERS
		
		//direccion del garante
		
		private String calleGarante;
		private String numIntGarante;
		private String numExtGarante;
		private String coloniaGarante;
		private String codPostalGarante;
		private String estadoGarante;
		private String municipioGarante;
		
		//fin direccion del garante

		private String localidadIDGarante;
		private String ColoniaID;
		
		private String estatusSolicitud;
		private List lestatusSolicitud;
		private String proporcion;
		private String usufructuaria;
		//Gmodulo agro
		
		private String sustituyeGL;
		private List lsustituyeGL;
		
		// validaciones
		private String montoDisponible;
		private String montoGarantia;
		private String montoAvaluado;
		
		public String getPropietario() {
			return propietario;
		}
		public String getCalleGarante() {
			return calleGarante;
		}
		public void setCalleGarante(String calleGarante) {
			this.calleGarante = calleGarante;
		}
		public String getNumIntGarante() {
			return numIntGarante;
		}
		public void setNumIntGarante(String numIntGarante) {
			this.numIntGarante = numIntGarante;
		}
		public String getNumExtGarante() {
			return numExtGarante;
		}
		public void setNumExtGarante(String numExtGarante) {
			this.numExtGarante = numExtGarante;
		}
		public String getColoniaGarante() {
			return coloniaGarante;
		}
		public void setColoniaGarante(String coloniaGarante) {
			this.coloniaGarante = coloniaGarante;
		}
		public String getCodPostalGarante() {
			return codPostalGarante;
		}
		public void setCodPostalGarante(String codPostalGarante) {
			this.codPostalGarante = codPostalGarante;
		}
		public String getEstadoGarante() {
			return estadoGarante;
		}
		public void setEstadoGarante(String estadoGarante) {
			this.estadoGarante = estadoGarante;
		}
		public String getMunicipioGarante() {
			return municipioGarante;
		}
		public void setMunicipioGarante(String municipioGarante) {
			this.municipioGarante = municipioGarante;
		}
		public String getSucursalID() {
			return sucursalID;
		}
		public void setSucursalID(String sucursalID) {
			this.sucursalID = sucursalID;
		}
		public String getGaranteNombre() {
			return garanteNombre;
		}
		public void setGaranteNombre(String garanteNombre) {
			this.garanteNombre = garanteNombre;
		}
		public String getRelGarantCred() {
			return relGarantCred;
		}
		public void setRelGarantCred(String relGarantCred) {
			this.relGarantCred = relGarantCred;
		}
		public String getRequiereGarantia() {
			return requiereGarantia;
		}
		public void setRequiereGarantia(String requiereGarantia) {
			this.requiereGarantia = requiereGarantia;
		}
		public String getFechaRegistro() {
			return fechaRegistro;
		}
		public void setFechaRegistro(String fechaRegistro) {
			this.fechaRegistro = fechaRegistro;
		}
		public String getClienteIDProp() {
			return clienteIDProp;
		}
		public void setClienteIDProp(String clienteIDProp) {
			this.clienteIDProp = clienteIDProp;
		}
		public String getProspectoIDProp() {
			return prospectoIDProp;
		}
		public void setProspectoIDProp(String prospectoIDProp) {
			this.prospectoIDProp = prospectoIDProp;
		}
		public String getAsegurador() {
			return asegurador;
		}
		public void setAsegurador(String asegurador) {
			this.asegurador = asegurador;
		}
		public String getNumPoliza() {
			return numPoliza;
		}
		public void setNumPoliza(String numPoliza) {
			this.numPoliza = numPoliza;
		}
		public String getFolioRegistro() {
			return folioRegistro;
		}
		public void setFolioRegistro(String folioRegistro) {
			this.folioRegistro = folioRegistro;
		}
		public String getNombreAutoridad() {
			return nombreAutoridad;
		}
		public void setNombreAutoridad(String nombreAutoridad) {
			this.nombreAutoridad = nombreAutoridad;
		}
		public String getCargoAutoridad() {
			return cargoAutoridad;
		}
		public void setCargoAutoridad(String cargoAutoridad) {
			this.cargoAutoridad = cargoAutoridad;
		}
		public String getNotarioID() {
			return notarioID;
		}
		public void setNotarioID(String notarioID) {
			this.notarioID = notarioID;
		}
		public String getFechaCompFactura() {
			return fechaCompFactura;
		}
		public void setFechaCompFactura(String fechaCompFactura) {
			this.fechaCompFactura = fechaCompFactura;
		}
		public String getRfcEmisor() {
			return rfcEmisor;
		}
		public void setRfcEmisor(String rfcEmisor) {
			this.rfcEmisor = rfcEmisor;
		}
		public String getValorFactura() {
			return valorFactura;
		}
		public void setValorFactura(String valorFactura) {
			this.valorFactura = valorFactura;
		}
		public String getSerieFactura() {
			return serieFactura;
		}
		public void setSerieFactura(String serieFactura) {
			this.serieFactura = serieFactura;
		}
		public String getReferenciafact() {
			return referenciafact;
		}
		public void setReferenciafact(String referenciafact) {
			this.referenciafact = referenciafact;
		}
		public String getFechagravemen() {
			return fechagravemen;
		}
		public void setFechagravemen(String fechagravemen) {
			this.fechagravemen = fechagravemen;
		}
		public String getMontoGravemen() {
			return montoGravemen;
		}
		public void setMontoGravemen(String montoGravemen) {
			this.montoGravemen = montoGravemen;
		}
		public String getNombBenefiGrav() {
			return nombBenefiGrav;
		}
		public void setNombBenefiGrav(String nombBenefiGrav) {
			this.nombBenefiGrav = nombBenefiGrav;
		}
		public void setPropietario(String propietario) {
			this.propietario = propietario;
		}
		public String getNombrePropUno() {
			return nombrePropUno;
		}
		public void setNombrePropUno(String nombrePropUno) {
			this.nombrePropUno = nombrePropUno;
		}
		public String getNombrePropDos() {
			return nombrePropDos;
		}
		public void setNombrePropDos(String nombrePropDos) {
			this.nombrePropDos = nombrePropDos;
		}
		public String getTipoDocumentoID() {
			return tipoDocumentoID;
		}
		public void setTipoDocumentoID(String tipoDocumentoID) {
			this.tipoDocumentoID = tipoDocumentoID;
		}
		public List getLgarantiaID() {
			return lgarantiaID;
		}
		public void setLgarantiaID(List lgarantiaID) {
			this.lgarantiaID = lgarantiaID;
		}
		public List getLmontoAsignado() {
			return lmontoAsignado;
		}
		public void setLmontoAsignado(List lmontoAsignado) {
			this.lmontoAsignado = lmontoAsignado;
		}
		public String getNumIdentificacion() {
			return numIdentificacion;
		}
		public void setNumIdentificacion(String numIdentificacion) {
			this.numIdentificacion = numIdentificacion;
		}
		public String getClasifGarantiaDesc() {
			return clasifGarantiaDesc;
		}
		public String getSolicitudCreditoID() {
			return solicitudCreditoID;
		}
		public void setSolicitudCreditoID(String solicitudCreditoID) {
			this.solicitudCreditoID = solicitudCreditoID;
		}
		public String getCreditoID() {
			return creditoID;
		}
		public void setCreditoID(String creditoID) {
			this.creditoID = creditoID;
		}
		public void setClasifGarantiaDesc(String clasifGarantiaDesc) {
			this.clasifGarantiaDesc = clasifGarantiaDesc;
		}
		public String getGarantiaID() {
			return garantiaID;
		}
		public void setGarantiaID(String garantiaID) {
			this.garantiaID = garantiaID;
		}
		public String getProspectoID() {
			return prospectoID;
		}
		public void setProspectoID(String prospectoID) {
			this.prospectoID = prospectoID;
		}
		public String getClienteID() {
			return clienteID;
		}
		public void setClienteID(String clienteID) {
			this.clienteID = clienteID;
		}
		public String getAvalID() {
			return avalID;
		}
		public void setAvalID(String avalID) {
			this.avalID = avalID;
		}
		public String getGaranteID() {
			return garanteID;
		}
		public void setGaranteID(String garanteID) {
			this.garanteID = garanteID;
		}
		public String getTipoGarantiaID() {
			return tipoGarantiaID;
		}
		public void setTipoGarantiaID(String tipoGarantiaID) {
			this.tipoGarantiaID = tipoGarantiaID;
		}
		public String getClasifGarantiaID() {
			return clasifGarantiaID;
		}
		public void setClasifGarantiaID(String clasifGarantiaID) {
			this.clasifGarantiaID = clasifGarantiaID;
		}
		public String getValorComercial() {
			return valorComercial;
		}
		public void setValorComercial(String valorComercial) {
			this.valorComercial = valorComercial;
		}
		public String getObservaciones() {
			return observaciones;
		}
		public void setObservaciones(String observaciones) {
			this.observaciones = observaciones;
		}
		public String getEstadoID() {
			return estadoID;
		}
		public void setEstadoID(String estadoID) {
			this.estadoID = estadoID;
		}
		public String getMunicipioID() {
			return municipioID;
		}
		public void setMunicipioID(String municipioID) {
			this.municipioID = municipioID;
		}
		public String getCalle() {
			return calle;
		}
		public void setCalle(String calle) {
			this.calle = calle;
		}
		public String getNumero() {
			return numero;
		}
		public void setNumero(String numero) {
			this.numero = numero;
		}
		public String getNumeroInt() {
			return numeroInt;
		}
		public void setNumeroInt(String numeroInt) {
			this.numeroInt = numeroInt;
		}
		public String getLote() {
			return lote;
		}
		public void setLote(String lote) {
			this.lote = lote;
		}
		public String getManzana() {
			return manzana;
		}
		public void setManzana(String manzana) {
			this.manzana = manzana;
		}
		public String getColonia() {
			return colonia;
		}
		public void setColonia(String colonia) {
			this.colonia = colonia;
		}
		public String getCodigoPostal() {
			return codigoPostal;
		}
		public void setCodigoPostal(String codigoPostal) {
			this.codigoPostal = codigoPostal;
		}
		public String getM2Construccion() {
			return m2Construccion;
		}
		public void setM2Construccion(String m2Construccion) {
			this.m2Construccion = m2Construccion;
		}
		public String getM2Terreno() {
			return m2Terreno;
		}
		public void setM2Terreno(String m2Terreno) {
			this.m2Terreno = m2Terreno;
		}
		public String getAsegurado() {
			return asegurado;
		}
		public void setAsegurado(String asegurado) {
			this.asegurado = asegurado;
		}
		public String getVencimientoPoliza() {
			return vencimientoPoliza;
		}
		public void setVencimientoPoliza(String vencimientoPoliza) {
			this.vencimientoPoliza = vencimientoPoliza;
		}
		public String getFechaValuacion() {
			return fechaValuacion;
		}
		public void setFechaValuacion(String fechaValuacion) {
			this.fechaValuacion = fechaValuacion;
		}
		public String getNumAvaluo() {
			return numAvaluo;
		}
		public void setNumAvaluo(String numAvaluo) {
			this.numAvaluo = numAvaluo;
		}
		public String getNombreValuador() {
			return nombreValuador;
		}
		public void setNombreValuador(String nombreValuador) {
			this.nombreValuador = nombreValuador;
		}
		public String getVerificada() {
			return verificada;
		}
		public void setVerificada(String verificada) {
			this.verificada = verificada;
		}
		public String getFechaVerificacion() {
			return fechaVerificacion;
		}
		public void setFechaVerificacion(String fechaVerificacion) {
			this.fechaVerificacion = fechaVerificacion;
		}
		public String getTipoGravemen() {
			return tipoGravemen;
		}
		public void setTipoGravemen(String tipoGravemen) {
			this.tipoGravemen = tipoGravemen;
		}
		public String getTipoInsCaptacion() {
			return tipoInsCaptacion;
		}
		public void setTipoInsCaptacion(String tipoInsCaptacion) {
			this.tipoInsCaptacion = tipoInsCaptacion;
		}
		public String getInsCaptacionID() {
			return insCaptacionID;
		}
		public void setInsCaptacionID(String insCaptacionID) {
			this.insCaptacionID = insCaptacionID;
		}
		public String getMontoAsignado() {
			return montoAsignado;
		}
		public void setMontoAsignado(String montoAsignado) {
			this.montoAsignado = montoAsignado;
		}
		public String getEstatus() {
			return estatus;
		}
		public void setEstatus(String estatus) {
			this.estatus = estatus;
		}
		public String getNoIdentificacion() {
			return noIdentificacion;
		}
		public void setNoIdentificacion(String noIdentificacion) {
			this.noIdentificacion = noIdentificacion;
		}
		public String getLocalidadIDGarante() {
			return localidadIDGarante;
		}
		public void setLocalidadIDGarante(String localidadIDGarante) {
			this.localidadIDGarante = localidadIDGarante;
		}
		public String getColoniaID() {
			return ColoniaID;
		}
		public void setColoniaID(String coloniaID) {
			ColoniaID = coloniaID;
		}
		public String getEstatusSolicitud() {
			return estatusSolicitud;
		}
		public void setEstatusSolicitud(String estatusSolicitud) {
			this.estatusSolicitud = estatusSolicitud;
		}
		public List getLestatusSolicitud() {
			return lestatusSolicitud;
		}
		public void setLestatusSolicitud(List lestatusSolicitud) {
			this.lestatusSolicitud = lestatusSolicitud;
		}
		public String getMontoAvaluo() {
			return montoAvaluo;
		}
		public void setMontoAvaluo(String montoAvaluo) {
			this.montoAvaluo = montoAvaluo;
		}
		public String getSustituyeGL() {
			return sustituyeGL;
		}
		public void setSustituyeGL(String sustituyeGL) {
			this.sustituyeGL = sustituyeGL;
		}
		public List getLsustituyeGL() {
			return lsustituyeGL;
		}
		public void setLsustituyeGL(List lsustituyeGL) {
			this.lsustituyeGL = lsustituyeGL;
		}
		public String getProporcion() {
			return proporcion;
		}
		public void setProporcion(String proporcion) {
			this.proporcion = proporcion;
		}
		public String getUsufructuaria() {
			return usufructuaria;
		}
		public void setUsufructuaria(String usufructuaria) {
			this.usufructuaria = usufructuaria;
		}
	public String getMontoDisponible() {
		return montoDisponible;
	}
	public void setMontoDisponible(String montoDisponible) {
		this.montoDisponible = montoDisponible;
	}
	public String getMontoGarantia() {
		return montoGarantia;
	}
	public void setMontoGarantia(String montoGarantia) {
		this.montoGarantia = montoGarantia;
	}
	public String getMontoAvaluado() {
		return montoAvaluado;
	}
	public void setMontoAvaluado(String montoAvaluado) {
		this.montoAvaluado = montoAvaluado;
	}
}
