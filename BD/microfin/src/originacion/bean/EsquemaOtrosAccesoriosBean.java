package originacion.bean;

import general.bean.BaseBean;

import java.util.List;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

public class EsquemaOtrosAccesoriosBean extends BaseBean{
	private String producCreditoID;
	private String descripcion;
	private String accesorioID;
	private String institNominaID;
	private String IVA;
	private String formaCobro;
	private String tipoPago;
	private String baseCalculo;
	private String montoAccesorio;
	private String montoIVAAccesorio;
	private String cobraIVA;
	private String generaInteres;
	private String cobraIVAInteres;
	private String clienteID;
	private String montoCredito;
	private String plazoID;
	private String solicitudCreditoID;
	private String creditoID;
	private String nombreCorto;
	private String montoPorcentaje;
	private String nivelID;
	private String saldoAccesorio;
	private String saldoIVAAccesorio;
	private String montoPagado;
	private String cicloIni;
	private String cicloFin;
	private String convenioID;
	private String montoMin;
	private String montoMax;
	private List<String> conveniosSeleccionadosID;
	private List<String> plazosSeleccionadosID;
	private String numConveniosSeleccionados;
	private String numPlazosSeleccionados;
	private String empresaNominaID;
	private String montoInteres;
	private String montoIVAInteres;
	private String montoIntCuota;
	private String montoIVAIntCuota;
	private String amortizacionID;
	private String contadorAccesorios;
	private String encabezadoLista;
	private String montoCuota;
	private String montoIVACuota;
	private String numTransacSim;
	private String numAmortizacion;
	
	public String getEmpresaNominaID() {
		return empresaNominaID;
	}
	public void setEmpresaNominaID(String empresaNominaID) {
		this.empresaNominaID = empresaNominaID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String productoCreditoID) {
		this.producCreditoID = productoCreditoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getAccesorioID() {
		return accesorioID;
	}
	public void setAccesorioID(String accesorioID) {
		this.accesorioID = accesorioID;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getIVA() {
		return IVA;
	}
	public void setIVA(String iVA) {
		IVA = iVA;
	}
	public String getFormaCobro() {
		return formaCobro;
	}
	public void setFormaCobro(String formaCobro) {
		this.formaCobro = formaCobro;
	}
	public String getTipoPago() {
		return tipoPago;
	}
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}
	public String getBaseCalculo() {
		return baseCalculo;
	}
	public void setBaseCalculo(String baseCalculo) {
		this.baseCalculo = baseCalculo;
	}
	public String getMontoAccesorio() {
		return montoAccesorio;
	}
	public void setMontoAccesorio(String montoAccesorio) {
		this.montoAccesorio = montoAccesorio;
	}
	public String getMontoIVAAccesorio() {
		return montoIVAAccesorio;
	}
	public void setMontoIVAAccesorio(String montoIVAAccesorio) {
		this.montoIVAAccesorio = montoIVAAccesorio;
	}
	public String getCobraIVA() {
		return cobraIVA;
	}
	public void setCobraIVA(String cobraIVA) {
		this.cobraIVA = cobraIVA;
	}
	public String getGeneraInteres() {
		return generaInteres;
	}
	public void setGeneraInteres(String generaInteres) {
		this.generaInteres = generaInteres;
	}
	public String getCobraIVAInteres() {
		return cobraIVAInteres;
	}
	public void setCobraIVAInteres(String cobraIVAInteres) {
		this.cobraIVAInteres = cobraIVAInteres;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
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
	public String getNombreCorto() {
		return nombreCorto;
	}
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}
	public String getMontoPorcentaje() {
		return montoPorcentaje;
	}
	public void setMontoPorcentaje(String montoPorcentaje) {
		this.montoPorcentaje = montoPorcentaje;
	}
	public String getNivelID() {
		return nivelID;
	}
	public void setNivelID(String nivelID) {
		this.nivelID = nivelID;
	}
	public String getSaldoAccesorio() {
		return saldoAccesorio;
	}
	public void setSaldoAccesorio(String saldoAccesorio) {
		this.saldoAccesorio = saldoAccesorio;
	}
	public String getSaldoIVAAccesorio() {
		return saldoIVAAccesorio;
	}
	public void setSaldoIVAAccesorio(String saldoIVAAccesorio) {
		this.saldoIVAAccesorio = saldoIVAAccesorio;
	}
	public String getMontoPagado() {
		return montoPagado;
	}
	public void setMontoPagado(String montoPagado) {
		this.montoPagado = montoPagado;
	}
	public String getCicloIni() {
		return cicloIni;
	}
	public void setCicloIni(String cicloIni) {
		this.cicloIni = cicloIni;
	}
	public String getCicloFin() {
		return cicloFin;
	}
	public void setCicloFin(String cicloFin) {
		this.cicloFin = cicloFin;
	}
	public String getConvenioID() {
		return convenioID;
	}
	public void setConvenioID(String convenioID) {
		this.convenioID = convenioID;
	}
	public String getMontoMin() {
		return montoMin;
	}
	public void setMontoMin(String montoMin) {
		this.montoMin = montoMin;
	}
	public String getMontoMax() {
		return montoMax;
	}
	public void setMontoMax(String montoMax) {
		this.montoMax = montoMax;
	}
	public List<String> getConveniosSeleccionadosID() {
		return conveniosSeleccionadosID;
	}
	public void setConveniosSeleccionadosID(List<String> conveniosSeleccionadosID) {
		this.conveniosSeleccionadosID = conveniosSeleccionadosID;
	}
	public List<String> getPlazosSeleccionadosID() {
		return plazosSeleccionadosID;
	}
	public void setPlazosSeleccionadosID(List<String> plazosSeleccionadosID) {
		this.plazosSeleccionadosID = plazosSeleccionadosID;
	}
	public String getNumConveniosSeleccionados() {
		return numConveniosSeleccionados;
	}
	public void setNumConveniosSeleccionados(String numConveniosSeleccionados) {
		this.numConveniosSeleccionados = numConveniosSeleccionados;
	}
	public String getNumPlazosSeleccionados() {
		return numPlazosSeleccionados;
	}
	public void setNumPlazosSeleccionados(String numPlazosSeleccionados) {
		this.numPlazosSeleccionados = numPlazosSeleccionados;
	}
	
	@Override
	public int hashCode() {
		return new HashCodeBuilder()
        	.append(this.montoPorcentaje)
        	.append(this.nivelID)
        	.append(this.cicloIni)
        	.append(this.cicloFin)
        	.append(this.montoMin)
        	.append(this.montoMax)
        	.toHashCode();
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof EsquemaOtrosAccesoriosBean == false){
			return false;
		}

		if (this == obj){
			return true;
		}

		final EsquemaOtrosAccesoriosBean otherObject = (EsquemaOtrosAccesoriosBean) obj;

		return new EqualsBuilder()
			.append(this.montoPorcentaje, otherObject.montoPorcentaje)
			.append(this.nivelID, otherObject.nivelID)
			.append(this.cicloIni, otherObject.cicloIni)
        	.append(this.cicloFin, otherObject.cicloFin)
        	.append(this.montoMin, otherObject.montoMin)
        	.append(this.montoMax, otherObject.montoMax)
	        .isEquals();
	}
	public String getMontoInteres() {
		return montoInteres;
	}
	public void setMontoInteres(String montoInteres) {
		this.montoInteres = montoInteres;
	}
	public String getMontoIVAInteres() {
		return montoIVAInteres;
	}
	public void setMontoIVAInteres(String montoIVAInteres) {
		this.montoIVAInteres = montoIVAInteres;
	}
	public String getMontoIntCuota() {
		return montoIntCuota;
	}
	public void setMontoIntCuota(String montoIntCuota) {
		this.montoIntCuota = montoIntCuota;
	}
	public String getMontoIVAIntCuota() {
		return montoIVAIntCuota;
	}
	public void setMontoIVAIntCuota(String montoIVAIntCuota) {
		this.montoIVAIntCuota = montoIVAIntCuota;
	}
	public String getAmortizacionID() {
		return amortizacionID;
	}
	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
	}
	public String getContadorAccesorios() {
		return contadorAccesorios;
	}
	public void setContadorAccesorios(String contadorAccesorios) {
		this.contadorAccesorios = contadorAccesorios;
	}
	public String getEncabezadoLista() {
		return encabezadoLista;
	}
	public void setEncabezadoLista(String encabezadoLista) {
		this.encabezadoLista = encabezadoLista;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getMontoIVACuota() {
		return montoIVACuota;
	}
	public void setMontoIVACuota(String montoIVACuota) {
		this.montoIVACuota = montoIVACuota;
	}
	public String getNumTransacSim() {
		return numTransacSim;
	}
	public void setNumTransacSim(String numTransacSim) {
		this.numTransacSim = numTransacSim;
	}
	public String getNumAmortizacion() {
		return numAmortizacion;
	}
	public void setNumAmortizacion(String numAmortizacion) {
		this.numAmortizacion = numAmortizacion;
	}

}
