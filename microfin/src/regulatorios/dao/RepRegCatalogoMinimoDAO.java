package regulatorios.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import regulatorios.bean.RepRegCatalogoMinimoBean;

public class RepRegCatalogoMinimoDAO extends BaseDAO {
	
	//Variables
	int numRepExcel=1; // variable para el reporte en excel de movimientos por cuenta contable
	
	
	public RepRegCatalogoMinimoDAO() {
		super();
	}

	// ===================== CSV =================================== //
	public List <RepRegCatalogoMinimoBean> regCatalogoMinimoCSVVersion2015(RepRegCatalogoMinimoBean repRegCatalogoMinimoBean, int tipoLista, int version){
		String query = "call REGCATALOGOMINIMOREP(" +
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
				"regCatalogoMinimoCSVVersion2015",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCATALOGOMINIMOREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepRegCatalogoMinimoBean repRegCatalogoMinimo = new RepRegCatalogoMinimoBean();
				repRegCatalogoMinimo.setValor(resultSet.getString("Valor"));
				return repRegCatalogoMinimo;	 
			}
		});
		return matches;
	}
	
	
	// =========================== S O C A P ===============================================//
	
	public List <RepRegCatalogoMinimoBean> regCatalogoMinimoVersionSOCAP(RepRegCatalogoMinimoBean repRegCatalogoMinimoBean, int tipoLista, int version){
		try{
		String query = "call REGCATALOGOMINIMOREP(" +
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
				"regCatalogoMinimoVersionSOCAP",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCATALOGOMINIMOREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				int count = resultSet.getMetaData().getColumnCount();
				RepRegCatalogoMinimoBean repRegCatalogoMinimo = new RepRegCatalogoMinimoBean();
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
	
	
	public List <RepRegCatalogoMinimoBean> regCatalogoMinimoVersionSOFIPO(RepRegCatalogoMinimoBean repRegCatalogoMinimoBean, int tipoLista, int version){
		try{
		String query = "call REGCATALOGOMINIMOREP(" +
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
				"regCatalogoMinimoVersionSOFIPO",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCATALOGOMINIMOREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				int count = resultSet.getMetaData().getColumnCount();
				RepRegCatalogoMinimoBean repRegCatalogoMinimo = new RepRegCatalogoMinimoBean();
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
				repRegCatalogoMinimo.setMonedaExt(resultSet.getString("MonedaExt"));
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

