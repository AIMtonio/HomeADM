package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import general.dao.BaseDAO;
import herramientas.Constantes;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.RowMapper;
import contabilidad.bean.ReporteBalanzaContableBean;
import contabilidad.bean.ReportesContablesBean;
 
public class ReportesContablesDAO extends BaseDAO {
	
	//Variables
	int numRepExcel=1; // variable para el reporte en excel de movimientos por cuenta contable
	
	public ReportesContablesDAO() {
		super();
	}
	

	public List <ReporteBalanzaContableBean>consultaBalanzaComprobacion(ReporteBalanzaContableBean balanzaContableBean, int tipoLista){
		String query = "call BALANZACONTAREP("
				+ "?,?,?,?,?,"
				+ "?,?,?,?,?,"
				+ "?,?,?,?,?,"
				+ "?,?,?,?);";
		Object[] parametros = {
					balanzaContableBean.getEjercicio(),
					balanzaContableBean.getPeriodo(),
					balanzaContableBean.getFecha(),
					balanzaContableBean.getTipoConsulta(),
					balanzaContableBean.getSaldoCero(),
					
					balanzaContableBean.getCifras(),
					balanzaContableBean.getCcInicial(),
					balanzaContableBean.getCcFinal(),
					balanzaContableBean.getCuentaIni(),
					balanzaContableBean.getCuentaFin(),
					
					balanzaContableBean.getNivelDetalle(),
					balanzaContableBean.getTipoBalanza(),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					
					parametrosAuditoriaBean.getDireccionIP(),
					"ReportesContablesDAO.consultaBalanzaComprobacion",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion(),
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BALANZACONTAREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteBalanzaContableBean reporteBalanza = new ReporteBalanzaContableBean();
				//# , , , , , , , , , , SumaSalDeu, SumaSalAcr

				reporteBalanza.setCuentaContable(resultSet.getString("CuentaContable"));
				reporteBalanza.setConcepto(resultSet.getString("DescripcionCuenta"));
				reporteBalanza.setSaldoInicial(resultSet.getString("SaldoInicial"));
				reporteBalanza.setSaldoIniAcreed(resultSet.getString("SaldoInicialAcre"));
				reporteBalanza.setCargos(resultSet.getString("Cargos"));
				reporteBalanza.setAbonos(resultSet.getString("Abonos"));
				reporteBalanza.setSaldoDeudor(resultSet.getString("SaldoDeudor"));
				reporteBalanza.setSaldoAcreedor(resultSet.getString("SaldoAcreedor"));
				reporteBalanza.setFecha(resultSet.getString("fecha"));
				reporteBalanza.setSumaSalIni(resultSet.getDouble("SumaSalIni"));
				reporteBalanza.setSumaSalIniAcre(resultSet.getDouble("SumaSalIniAcre"));
				reporteBalanza.setSumaCargos(resultSet.getDouble("SumaCargos"));
				reporteBalanza.setSumaAbonos(resultSet.getDouble("SumaAbonos"));
				reporteBalanza.setSumaSalDeu(resultSet.getDouble("SumaSalDeu"));
				reporteBalanza.setSumaSalAcr(resultSet.getDouble("SumaSalAcr"));
				
				reporteBalanza.setCentroCosto(resultSet.getString("CentroCosto"));
				reporteBalanza.setGrupo(resultSet.getString("Grupo"));
				return reporteBalanza;	 
			}
		});
		return matches;
	}

	/**
	 * Trae el detalle del reporte movimientos por cuenta contable
	 * @param reportesContablesBean trae los valores para filtrar el reporte
	 * @return	Regresa la lista con los valores del detalle del reporte de movimientos por cuenta contable
	 */
	public List<ReportesContablesBean> consultaRepMovimientosCta(ReportesContablesBean reportesContablesBean) {
		List<ReportesContablesBean> listaMovCta = null;
		try {
			String query = "call DETALLEPOLIZAREP(?,?,?,?,?,  ?,?,?,?,?  ,?,?,?,?,?, ?,?);";
			Object[] parametros = {
					reportesContablesBean.getCuentaCompleta(),
					reportesContablesBean.getCuentaCompletaFin(),
					reportesContablesBean.getFechaIni(),
					reportesContablesBean.getFechaFin(),
					reportesContablesBean.getPrimerRango(),
					reportesContablesBean.getSegundoRango(),
					reportesContablesBean.getPrimerCentroCostos(),
					reportesContablesBean.getSegundoCentroCostos(),
					reportesContablesBean.getTipoInstrumentoID(),
					numRepExcel,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ReportesContablesDAO.consultaRepMovimientosCta",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call DETALLEPOLIZAREP(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReportesContablesBean reporteMovCta = new ReportesContablesBean();
					reporteMovCta.setEmpresaID(resultSet.getString("EmpresaID"));
					reporteMovCta.setPolizaID(resultSet.getString("PolizaID"));
					reporteMovCta.setFecha(resultSet.getString("Fecha"));
					reporteMovCta.setCentroCostoID(resultSet.getString("CentroCostoID"));
					reporteMovCta.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
					reporteMovCta.setDesCuentaCompleta(resultSet.getString("NombreCuenta"));
					reporteMovCta.setCargos(resultSet.getString("Cargos"));
					reporteMovCta.setAbonos(resultSet.getString("Abonos"));
					reporteMovCta.setDescripcion(resultSet.getString("Descripcion"));
					reporteMovCta.setInstrumentos(resultSet.getString("Instrumento"));
					reporteMovCta.setSaldos(resultSet.getString("Saldo"));
					reporteMovCta.setSaldoInicial(resultSet.getString("saldoInicial"));
					reporteMovCta.setSaldoFinal(resultSet.getString("SaldoFinal"));
					return reporteMovCta;
				}
			});
			listaMovCta = matches;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en datalle de poliza", e);
		}
		return listaMovCta;
	}
	
	
}

