package nomina.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.CuentasTransferBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import nomina.bean.ActualizaEstatusEmpBean;
import nomina.bean.BitacoraDomiciPagosBean;

public class BitacoraDomiciPagosDAO extends BaseDAO{
	
	public ParametrosSesionBean parametrosSesionBean = null;
	
	public BitacoraDomiciPagosDAO(){
		super();
	}
	
	/*Consulta unicamente la fecha en la que se genero la carga del lote de pagos de domiciliacion*/
	public BitacoraDomiciPagosBean consultaBitacoraFecha(int tipoConsulta, BitacoraDomiciPagosBean bitacoraDomiciPagosBean){
		String query = "call BITACORADOMICIPAGOSCON(" +
				"?,?,?,?,?, ?,?,?,?,?," +
				"?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(bitacoraDomiciPagosBean.getFolioID()),
				Constantes.FECHA_VACIA,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"BitacoraDomiciPagosDAO.consultaBitacoraFecha",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORADOMICIPAGOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				BitacoraDomiciPagosBean benResultado = new BitacoraDomiciPagosBean();
				
				benResultado.setFolioID(resultSet.getString("FolioID"));
				benResultado.setFecha(resultSet.getString("Fecha"));
				

				return benResultado;
			}
		});

		return matches.size() > 0 ? (BitacoraDomiciPagosBean) matches.get(0) : null;
	}
	
	
	
	/* Listado de Frecuencias del Credito por Folio de Pago de Domiciliacion */
	public List listaFrecuenciaDomiciPagos(BitacoraDomiciPagosBean bitacoraDomiciPagosBean,int tipoLista) {
		List  frecuenciaLis = null;
		try{
			// Query con el Store Procedure
			
			String query = "call BITACORADOMICIPAGOSLIS(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = { 
									
					bitacoraDomiciPagosBean.getFolioID(),
					Constantes.FECHA_VACIA,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,
									
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaFrecuenciaDomiciPagos",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORADOMICIPAGOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					BitacoraDomiciPagosBean resultadoBean = new BitacoraDomiciPagosBean();
					resultadoBean.setFrecuencia(resultSet.getString("Frecuencia"));
					resultadoBean.setDescFrecuencia(resultSet.getString("DescFrecuencia"));
					return resultadoBean;
				}
			});
		frecuenciaLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de frecuencias de pagos domiciliados", e);
		}
		return frecuenciaLis;
	}

	/* Listado de Frecuencias del Credito por Folio de Pago de Domiciliacion */
	public List listaReporteExcel(BitacoraDomiciPagosBean bitacoraDomiciPagosBean,int tipoLista) {
		List  frecuenciaLis = null;
		try{
			// Query con el Store Procedure
			
			String query = "call BITACORADOMICIPAGOSREP(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = { 
									
					Utileria.convierteEntero(bitacoraDomiciPagosBean.getFolioID()),
					Utileria.convierteFecha(bitacoraDomiciPagosBean.getFechaInicio()),
					Utileria.convierteFecha(bitacoraDomiciPagosBean.getFechaFin()),
					Utileria.convierteEntero(bitacoraDomiciPagosBean.getClienteID()),
					Utileria.convierteEntero(bitacoraDomiciPagosBean.getInstitNominaID()),
					bitacoraDomiciPagosBean.getFrecuencia(),
					tipoLista,
									
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaReporteExcel",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORADOMICIPAGOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					BitacoraDomiciPagosBean resultadoBean = new BitacoraDomiciPagosBean();
					resultadoBean.setFolioID(resultSet.getString("FolioID"));
					resultadoBean.setFecha(resultSet.getString("Fecha"));
					resultadoBean.setHora(resultSet.getString("Hora"));
					resultadoBean.setReferencia(resultSet.getString("Referencia"));
					resultadoBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),10));
					resultadoBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					resultadoBean.setCreditoID(resultSet.getString("CreditoID"));
					resultadoBean.setNombreInstitNomina(resultSet.getString("NombreInstit"));
					resultadoBean.setConvenio(resultSet.getString("ConvenioNominaID"));
					resultadoBean.setNombreInstitucion(resultSet.getString("NombreCorto"));
					resultadoBean.setCuentaClabe(resultSet.getString("CuentaClabe"));
					resultadoBean.setMontoAplicado(resultSet.getString("MontoAplicado"));
					resultadoBean.setMontoNoAplicado(resultSet.getString("MontoNoAplicado"));
					resultadoBean.setCuotasPendientes(resultSet.getString("CuotasPendientes"));
					resultadoBean.setMontoPendiente(resultSet.getString("MontoPendiente"));
					resultadoBean.setClaveDomicilia(resultSet.getString("ClaveDomicilia"));
					resultadoBean.setFrecuencia(resultSet.getString("Frecuencia"));
					resultadoBean.setFechaVencimiento(resultSet.getString("FechaVencimien"));
					resultadoBean.setMontoOtorgado(resultSet.getString("MontoDesemb"));
					resultadoBean.setNumCuotas(resultSet.getString("NumAmortizacion"));
					resultadoBean.setMontoCuota(resultSet.getString("MontoCuota"));
					resultadoBean.setReprocesado(resultSet.getString("Reprocesado"));
					resultadoBean.setNumTransaccion(resultSet.getString("NumTransaccion"));
																
					return resultadoBean;
				}
			});
		frecuenciaLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de frecuencias de pagos domiciliados para el reporte", e);
		}
		return frecuenciaLis;
	}
	
	
	
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
	
	
}
