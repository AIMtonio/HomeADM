package seguimiento.bean;

import general.bean.BaseBean;

import java.util.List;

public class SeguimientoBean extends BaseBean{
	private String seguimientoID;
	private String descripcion;
	private String categoriaID;
	private List productosID;
	private String cicloCteInicio;
	private String cicloCteFinal;
	private String estatus;
	private String ejecutorID;
	private String supervisorID;
	private String nivelAplicacion;
	private String aplicaCarteraVig;
	private String aplicaCarteraAtra;
	private String aplicaCarteraVen;
	private String carteraNoAplica;
	private String permiteManual;
	private String base;
	private String basePorcentaje;
	private String baseNumero;
	private String criterio;
	private List comboCriterio;
	private String compuerta;
	private String condici1;
	private String operador;
	private String condici2;
	private String maxEventos;
	private String claCondicion;
	private String claOperador;
	private String productoID;
	private List condiciOpc;
	private String conOpc;
	private List selecCompuerta;
	private List selecCondi1;
	private List selecOperador;
	private List selecCondi2;
	private List selecMaxEventos;
	private String periodicidad;
	private String diasOtorga;
	private String avanceCredito;
	private String diasAntLiq;
	private String diasAntCuota;
	private String diaMes;
	private String diaSemana;
	private String diaHabil;
	private String maxUltSegto;
	private String minUltSegto;
	private String plazoMaximo;	
	private List prograPeriodicidad;
	private List prograDiasOtorga;
	private List prograAvanceCredito;
	private List prograDiasAntLiq;
	private List prograDiasAntCuota;
	private List prograDiaMes;
	private List prograDiaSemana;
	private List prograDiaHabil;
	private List prograMaxUltSegto;
	private List prograMinUltSegto;
	private List prograPlazoMaximo;
	private List clasifCondicion;
	private List clasifOperador;
	private String lisPlazas;
	private String lisSucursal;
	private String lisEjecutivo;
	private String lisFondeo;
	private String plazaID;
	private String sucursalID;
	private String ejecutivoID;
	private String fondeadorID;
	private String recPropios;
	private String alcance;
	private String tipoGestorID;
	//Variables para reporte
	private String fechaInicio;
	private String fechaFin;
	private String resultadoID;
	private String recomendacionID;
	private String prodCreditoID;
	private String nomInstitucion;
	private String fechaEmision;
	private String usuarioID;
	private String nomUsuario;
	private String categoriaDesc;
	private String plazaDesc;
	private String sucursalDesc;
	private String prodCreditoDesc;
	private String gestorDesc;
	private String tipoGestorDesc;
	private String supervisorDesc;
	private String resultadoDesc;
	private String recomendaDesc;
	private String municipioID;
	private String numeroReporte;
	private String numeroLista;
	private String selecProgramada;
	private String selecSeguimiento;
	private String fechaInicioSeg;
	private String fechaFinSeg;
	private String  nombreUsuario; 
	
	
	public List getCondiciOpc() {
		return condiciOpc;
	}
	public void setCondiciOpc(List condiciOpc) {
		this.condiciOpc = condiciOpc;
	}
	public String getConOpc() {
		return conOpc;
	}
	public void setConOpc(String conOpc) {
		this.conOpc = conOpc;
	}
	public String getSeguimientoID() {
		return seguimientoID;
	}
	public void setSeguimientoID(String seguimientoID) {
		this.seguimientoID = seguimientoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCategoriaID() {
		return categoriaID;
	}
	public void setCategoriaID(String categoriaID) {
		this.categoriaID = categoriaID;
	}
	public List getProductosID() {
		return productosID;
	}
	public void setProductosID(List productosID) {
		this.productosID = productosID;
	}
	public String getCicloCteInicio() {
		return cicloCteInicio;
	}
	public void setCicloCteInicio(String cicloCteInicio) {
		this.cicloCteInicio = cicloCteInicio;
	}
	public String getCicloCteFinal() {
		return cicloCteFinal;
	}
	public void setCicloCteFinal(String cicloCteFinal) {
		this.cicloCteFinal = cicloCteFinal;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getEjecutorID() {
		return ejecutorID;
	}
	public void setEjecutorID(String ejecutorID) {
		this.ejecutorID = ejecutorID;
	}
	public String getSupervisorID() {
		return supervisorID;
	}
	public void setSupervisorID(String supervisorID) {
		this.supervisorID = supervisorID;
	}
	public String getNivelAplicacion() {
		return nivelAplicacion;
	}
	public void setNivelAplicacion(String nivelAplicacion) {
		this.nivelAplicacion = nivelAplicacion;
	}
	public String getAplicaCarteraVig() {
		return aplicaCarteraVig;
	}
	public void setAplicaCarteraVig(String aplicaCarteraVig) {
		this.aplicaCarteraVig = aplicaCarteraVig;
	}
	public String getAplicaCarteraAtra() {
		return aplicaCarteraAtra;
	}
	public void setAplicaCarteraAtra(String aplicaCarteraAtra) {
		this.aplicaCarteraAtra = aplicaCarteraAtra;
	}
	public String getAplicaCarteraVen() {
		return aplicaCarteraVen;
	}
	public void setAplicaCarteraVen(String aplicaCarteraVen) {
		this.aplicaCarteraVen = aplicaCarteraVen;
	}	
	public String getCarteraNoAplica() {
		return carteraNoAplica;
	}
	public void setCarteraNoAplica(String carteraNoAplica) {
		this.carteraNoAplica = carteraNoAplica;
	}
	public String getPermiteManual() {
		return permiteManual;
	}
	public void setPermiteManual(String permiteManual) {
		this.permiteManual = permiteManual;
	}	
	public String getBase() {
		return base;
	}
	public void setBase(String base) {
		this.base = base;
	}
	public String getBasePorcentaje() {
		return basePorcentaje;
	}
	public void setBasePorcentaje(String basePorcentaje) {
		this.basePorcentaje = basePorcentaje;
	}
	public String getBaseNumero() {
		return baseNumero;
	}
	public void setBaseNumero(String baseNumero) {
		this.baseNumero = baseNumero;
	}
	public String getCompuerta() {
		return compuerta;
	}
	public void setCompuerta(String compuerta) {
		this.compuerta = compuerta;
	}
	public String getCondici1() {
		return condici1;
	}
	public void setCondici1(String condici1) {
		this.condici1 = condici1;
	}
	public String getOperador() {
		return operador;
	}
	public void setOperador(String operador) {
		this.operador = operador;
	}
	public String getCondici2() {
		return condici2;
	}
	public void setCondici2(String condici2) {
		this.condici2 = condici2;
	}
	public String getMaxEventos() {
		return maxEventos;
	}
	public void setMaxEventos(String maxEventos) {
		this.maxEventos = maxEventos;
	}
	public String getClaCondicion() {
		return claCondicion;
	}
	public void setClaCondicion(String claCondicion) {
		this.claCondicion = claCondicion;
	}
	public String getClaOperador() {
		return claOperador;
	}
	public void setClaOperador(String claOperador) {
		this.claOperador = claOperador;
	}
	public List getSelecCompuerta() {
		return selecCompuerta;
	}
	public void setSelecCompuerta(List selecCompuerta) {
		this.selecCompuerta = selecCompuerta;
	}	
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getDiasOtorga() {
		return diasOtorga;
	}
	public void setDiasOtorga(String diasOtorga) {
		this.diasOtorga = diasOtorga;
	}
	public String getAvanceCredito() {
		return avanceCredito;
	}
	public void setAvanceCredito(String avanceCredito) {
		this.avanceCredito = avanceCredito;
	}
	public String getDiasAntLiq() {
		return diasAntLiq;
	}
	public void setDiasAntLiq(String diasAntLiq) {
		this.diasAntLiq = diasAntLiq;
	}
	public String getDiasAntCuota() {
		return diasAntCuota;
	}
	public void setDiasAntCuota(String diasAntCuota) {
		this.diasAntCuota = diasAntCuota;
	}
	public String getDiaMes() {
		return diaMes;
	}
	public void setDiaMes(String diaMes) {
		this.diaMes = diaMes;
	}
	public String getDiaSemana() {
		return diaSemana;
	}
	public void setDiaSemana(String diaSemana) {
		this.diaSemana = diaSemana;
	}
	public String getDiaHabil() {
		return diaHabil;
	}
	public void setDiaHabil(String diaHabil) {
		this.diaHabil = diaHabil;
	}
	public String getMaxUltSegto() {
		return maxUltSegto;
	}
	public void setMaxUltSegto(String maxUltSegto) {
		this.maxUltSegto = maxUltSegto;
	}
	public String getMinUltSegto() {
		return minUltSegto;
	}
	public void setMinUltSegto(String minUltSegto) {
		this.minUltSegto = minUltSegto;
	}
	public String getPlazoMaximo() {
		return plazoMaximo;
	}
	public void setPlazoMaximo(String plazoMaximo) {
		this.plazoMaximo = plazoMaximo;
	}	
	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}	
	public String getCriterio() {
		return criterio;
	}
	public void setCriterio(String criterio) {
		this.criterio = criterio;
	}	
	public List getComboCriterio() {
		return comboCriterio;
	}
	public void setComboCriterio(List comboCriterio) {
		this.comboCriterio = comboCriterio;
	}
	public List getSelecCondi1() {
		return selecCondi1;
	}
	public void setSelecCondi1(List selecCondi1) {
		this.selecCondi1 = selecCondi1;
	}
	public List getSelecOperador() {
		return selecOperador;
	}
	public void setSelecOperador(List selecOperador) {
		this.selecOperador = selecOperador;
	}
	public List getSelecCondi2() {
		return selecCondi2;
	}
	public void setSelecCondi2(List selecCondi2) {
		this.selecCondi2 = selecCondi2;
	}
	public List getSelecMaxEventos() {
		return selecMaxEventos;
	}
	public void setSelecMaxEventos(List selecMaxEventos) {
		this.selecMaxEventos = selecMaxEventos;
	}
	public List getPrograPeriodicidad() {
		return prograPeriodicidad;
	}
	public void setPrograPeriodicidad(List prograPeriodicidad) {
		this.prograPeriodicidad = prograPeriodicidad;
	}
	public List getPrograDiasOtorga() {
		return prograDiasOtorga;
	}
	public void setPrograDiasOtorga(List prograDiasOtorga) {
		this.prograDiasOtorga = prograDiasOtorga;
	}
	public List getPrograAvanceCredito() {
		return prograAvanceCredito;
	}
	public void setPrograAvanceCredito(List prograAvanceCredito) {
		this.prograAvanceCredito = prograAvanceCredito;
	}
	public List getPrograDiasAntLiq() {
		return prograDiasAntLiq;
	}
	public void setPrograDiasAntLiq(List prograDiasAntLiq) {
		this.prograDiasAntLiq = prograDiasAntLiq;
	}
	public List getPrograDiasAntCuota() {
		return prograDiasAntCuota;
	}
	public void setPrograDiasAntCuota(List prograDiasAntCuota) {
		this.prograDiasAntCuota = prograDiasAntCuota;
	}
	public List getPrograDiaMes() {
		return prograDiaMes;
	}
	public void setPrograDiaMes(List prograDiaMes) {
		this.prograDiaMes = prograDiaMes;
	}
	public List getPrograDiaSemana() {
		return prograDiaSemana;
	}
	public void setPrograDiaSemana(List prograDiaSemana) {
		this.prograDiaSemana = prograDiaSemana;
	}
	public List getPrograDiaHabil() {
		return prograDiaHabil;
	}
	public void setPrograDiaHabil(List prograDiaHabil) {
		this.prograDiaHabil = prograDiaHabil;
	}
	public List getPrograMaxUltSegto() {
		return prograMaxUltSegto;
	}
	public void setPrograMaxUltSegto(List prograMaxUltSegto) {
		this.prograMaxUltSegto = prograMaxUltSegto;
	}
	public List getPrograMinUltSegto() {
		return prograMinUltSegto;
	}
	public void setPrograMinUltSegto(List prograMinUltSegto) {
		this.prograMinUltSegto = prograMinUltSegto;
	}
	public List getPrograPlazoMaximo() {
		return prograPlazoMaximo;
	}
	public void setPrograPlazoMaximo(List prograPlazoMaximo) {
		this.prograPlazoMaximo = prograPlazoMaximo;
	}
	public List getClasifCondicion() {
		return clasifCondicion;
	}
	public void setClasifCondicion(List clasifCondicion) {
		this.clasifCondicion = clasifCondicion;
	}
	public List getClasifOperador() {
		return clasifOperador;
	}
	public void setClasifOperador(List clasifOperador) {
		this.clasifOperador = clasifOperador;
	}
	public String getPlazaID() {
		return plazaID;
	}
	public void setPlazaID(String plazaID) {
		this.plazaID = plazaID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getEjecutivoID() {
		return ejecutivoID;
	}
	public void setEjecutivoID(String ejecutivoID) {
		this.ejecutivoID = ejecutivoID;
	}
	public String getLisPlazas() {
		return lisPlazas;
	}
	public void setLisPlazas(String lisPlazas) {
		this.lisPlazas = lisPlazas;
	}
	public String getLisSucursal() {
		return lisSucursal;
	}
	public void setLisSucursal(String lisSucursal) {
		this.lisSucursal = lisSucursal;
	}
	public String getLisEjecutivo() {
		return lisEjecutivo;
	}
	public void setLisEjecutivo(String lisEjecutivo) {
		this.lisEjecutivo = lisEjecutivo;
	}
	public String getAlcance() {
		return alcance;
	}
	public void setAlcance(String alcance) {
		this.alcance = alcance;
	}
	public String getLisFondeo() {
		return lisFondeo;
	}
	public void setLisFondeo(String lisFondeo) {
		this.lisFondeo = lisFondeo;
	}
	public String getFondeadorID() {
		return fondeadorID;
	}
	public void setFondeadorID(String fondeadorID) {
		this.fondeadorID = fondeadorID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getResultadoID() {
		return resultadoID;
	}
	public void setResultadoID(String resultadoID) {
		this.resultadoID = resultadoID;
	}
	public String getRecomendacionID() {
		return recomendacionID;
	}
	public void setRecomendacionID(String recomendacionID) {
		this.recomendacionID = recomendacionID;
	}
	public String getProdCreditoID() {
		return prodCreditoID;
	}
	public void setProdCreditoID(String prodCreditoID) {
		this.prodCreditoID = prodCreditoID;
	}
	public String getNomInstitucion() {
		return nomInstitucion;
	}
	public void setNomInstitucion(String nomInstitucion) {
		this.nomInstitucion = nomInstitucion;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNomUsuario() {
		return nomUsuario;
	}
	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}
	public String getCategoriaDesc() {
		return categoriaDesc;
	}
	public void setCategoriaDesc(String categoriaDesc) {
		this.categoriaDesc = categoriaDesc;
	}
	public String getPlazaDesc() {
		return plazaDesc;
	}
	public void setPlazaDesc(String plazaDesc) {
		this.plazaDesc = plazaDesc;
	}
	public String getSucursalDesc() {
		return sucursalDesc;
	}
	public void setSucursalDesc(String sucursalDesc) {
		this.sucursalDesc = sucursalDesc;
	}
	public String getProdCreditoDesc() {
		return prodCreditoDesc;
	}
	public void setProdCreditoDesc(String prodCreditoDesc) {
		this.prodCreditoDesc = prodCreditoDesc;
	}
	public String getGestorDesc() {
		return gestorDesc;
	}
	public void setGestorDesc(String gestorDesc) {
		this.gestorDesc = gestorDesc;
	}
	public String getSupervisorDesc() {
		return supervisorDesc;
	}
	public void setSupervisorDesc(String supervisorDesc) {
		this.supervisorDesc = supervisorDesc;
	}
	public String getResultadoDesc() {
		return resultadoDesc;
	}
	public void setResultadoDesc(String resultadoDesc) {
		this.resultadoDesc = resultadoDesc;
	}
	public String getRecomendaDesc() {
		return recomendaDesc;
	}
	public void setRecomendaDesc(String recomendaDesc) {
		this.recomendaDesc = recomendaDesc;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getRecPropios() {
		return recPropios;
	}
	public void setRecPropios(String recPropios) {
		this.recPropios = recPropios;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNumeroReporte() {
		return numeroReporte;
	}
	public void setNumeroReporte(String numeroReporte) {
		this.numeroReporte = numeroReporte;
	}
	public String getNumeroLista() {
		return numeroLista;
	}
	public void setNumeroLista(String numeroLista) {
		this.numeroLista = numeroLista;
	}
	public String getTipoGestorID() {
		return tipoGestorID;
	}
	public void setTipoGestorID(String tipoGestorID) {
		this.tipoGestorID = tipoGestorID;
	}
	public String getTipoGestorDesc() {
		return tipoGestorDesc;
	}
	public void setTipoGestorDesc(String tipoGestorDesc) {
		this.tipoGestorDesc = tipoGestorDesc;
	}
	public String getSelecProgramada() {
		return selecProgramada;
	}
	public void setSelecProgramada(String selecProgramada) {
		this.selecProgramada = selecProgramada;
	}
	public String getSelecSeguimiento() {
		return selecSeguimiento;
	}
	public void setSelecSeguimiento(String selecSeguimiento) {
		this.selecSeguimiento = selecSeguimiento;
	}
	public String getFechaInicioSeg() {
		return fechaInicioSeg;
	}
	public void setFechaInicioSeg(String fechaInicioSeg) {
		this.fechaInicioSeg = fechaInicioSeg;
	}
	public String getFechaFinSeg() {
		return fechaFinSeg;
	}
	public void setFechaFinSeg(String fechaFinSeg) {
		this.fechaFinSeg = fechaFinSeg;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
}