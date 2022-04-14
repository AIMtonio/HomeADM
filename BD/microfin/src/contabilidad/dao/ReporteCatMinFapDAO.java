package contabilidad.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import contabilidad.bean.ReporteCatMinFapBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ReporteCatMinFapDAO extends BaseDAO {
	
	//Variables
		int numRepExcel=1; // variable para el reporte en excel de movimientos por cuenta contable
		
		
		public ReporteCatMinFapDAO() {
			super();
		}

		// ===================== CSV =================================== //
		public List <ReporteCatMinFapBean> regCatalogoMinimoCSVVersion2015(ReporteCatMinFapBean repRegCatalogoMinimoBean, int tipoLista, int version){
			String query = "call CATMINFAPREP(" +
					"?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(repRegCatalogoMinimoBean.getAnio()),
					Utileria.convierteEntero(repRegCatalogoMinimoBean.getMes()),
					tipoLista,
					version,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatalogoMinimoCSVVersion2015",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMINFAPREP(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteCatMinFapBean repRegCatalogoMinimo = new ReporteCatMinFapBean();
					repRegCatalogoMinimo.setValor(resultSet.getString("Valor"));
					return repRegCatalogoMinimo;	 
				}
			});
			return matches;
		}
		
		
		// =========================== S O C A P ===============================================//
		
		public List <ReporteCatMinFapBean> regCatalogoMinimoVersionSOCAP(ReporteCatMinFapBean repRegCatalogoMinimoBean, int tipoLista, int version){
			try{
			String query = "call CATMINFAPREP(" +
					"?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(repRegCatalogoMinimoBean.getAnio()),
					Utileria.convierteEntero(repRegCatalogoMinimoBean.getMes()),
					tipoLista,
					version,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatalogoMinimoVersionSOCAP",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMINFAPREP(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					int count = resultSet.getMetaData().getColumnCount();
					ReporteCatMinFapBean repRegCatalogoMinimo = new ReporteCatMinFapBean();
					repRegCatalogoMinimo.setEstadoFinanID(resultSet.getString("EstadoFinanID"));
					repRegCatalogoMinimo.setConceptoFinanID(resultSet.getString("ConceptoFinanID"));
					
					repRegCatalogoMinimo.setDescripcion(resultSet.getString("Descripcion"));
					repRegCatalogoMinimo.setDesplegado(resultSet.getString("Desplegado"));
					repRegCatalogoMinimo.setCuentaContable(resultSet.getString("CuentaContable"));

					repRegCatalogoMinimo.setEsCalculado(resultSet.getString("EsCalculado"));
					repRegCatalogoMinimo.setNombreCampo(resultSet.getString("NombreCampo"));
					repRegCatalogoMinimo.setEspacios(resultSet.getString("Espacios"));
					repRegCatalogoMinimo.setNegrita(resultSet.getString("Negrita"));
					repRegCatalogoMinimo.setSombreado(resultSet.getString("Sombreado"));

					repRegCatalogoMinimo.setCombinarCeldas(resultSet.getString("CombinarCeldas"));
					repRegCatalogoMinimo.setNumeroTransaccion(resultSet.getString("NumeroTransaccion"));
					repRegCatalogoMinimo.setFecha(resultSet.getString("Fecha"));
					repRegCatalogoMinimo.setMaxEspacios(resultSet.getString("MaxEspacios"));
					repRegCatalogoMinimo.setMonto(resultSet.getString("Monto"));
					return repRegCatalogoMinimo;	 
				}
			});
			return matches;
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
			return null;
		}
		
		
		
		
		// ======================= S O F I P O =========================================//
		
		
		public List <ReporteCatMinFapBean> regCatalogoMinimoVersionSOFIPO(ReporteCatMinFapBean repRegCatalogoMinimoBean, int tipoLista, int version){
			try{
			String query = "call CATMINFAPREP(" +
					"?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(repRegCatalogoMinimoBean.getAnio()),
					Utileria.convierteEntero(repRegCatalogoMinimoBean.getMes()),
					tipoLista,
					version,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatalogoMinimoVersionSOFIPO",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMINFAPREP(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					int count = resultSet.getMetaData().getColumnCount();
					ReporteCatMinFapBean repRegCatalogoMinimo = new ReporteCatMinFapBean();
					repRegCatalogoMinimo.setEstadoFinanID(resultSet.getString("EstadoFinanID"));
					repRegCatalogoMinimo.setConceptoFinanID(resultSet.getString("ConceptoFinanID"));
					
					repRegCatalogoMinimo.setDescripcion(resultSet.getString("Descripcion"));
					repRegCatalogoMinimo.setDesplegado(resultSet.getString("Desplegado"));
					repRegCatalogoMinimo.setCuentaContable(resultSet.getString("CuentaContable"));

					repRegCatalogoMinimo.setEsCalculado(resultSet.getString("EsCalculado"));
					repRegCatalogoMinimo.setNombreCampo(resultSet.getString("NombreCampo"));
					repRegCatalogoMinimo.setEspacios(resultSet.getString("Espacios"));
					repRegCatalogoMinimo.setNegrita(resultSet.getString("Negrita"));
					repRegCatalogoMinimo.setSombreado(resultSet.getString("Sombreado"));

					repRegCatalogoMinimo.setCombinarCeldas(resultSet.getString("CombinarCeldas"));
					repRegCatalogoMinimo.setNumeroTransaccion(resultSet.getString("NumeroTransaccion"));
					repRegCatalogoMinimo.setFecha(resultSet.getString("Fecha"));
					repRegCatalogoMinimo.setMaxEspacios(resultSet.getString("MaxEspacios"));
					repRegCatalogoMinimo.setSaldoFinal(resultSet.getString("SaldoFinal"));
					repRegCatalogoMinimo.setSaldoInicial(resultSet.getString("SaldoInicial"));
					repRegCatalogoMinimo.setCargos(resultSet.getString("Cargos"));
					repRegCatalogoMinimo.setAbonos(resultSet.getString("Abonos"));
					return repRegCatalogoMinimo;	 
				}
			});
			return matches;
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
			return null;
		}

}
