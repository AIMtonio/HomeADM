package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.core.CollectionFactory;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.JdbcUtils;

//import com.mysql.jdbc.ResultSetMetaData;

import tesoreria.bean.ConsolaBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
public class ConsolaDAO extends BaseDAO{
	
	public ConsolaBean consultaConcentrado(final String sucursalID, final String fechaDia){
		ConsolaBean consolaBean = null;
		try{
			String query = "call CONSOLACENTRALCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteEntero(sucursalID),
						fechaDia,
						
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ConsolaDAO.consultaConcentrado",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSOLACENTRALCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolaBean	consola = new ConsolaBean();
										
					//Ingresos
					consola.setCuentasBancos(resultSet.getString("saldoCuentas"));
					consola.setInversionBancarias(resultSet.getString("saldoInversiones"));
					consola.setEfectivoCaja(resultSet.getString("saldoVentanilla"));
					consola.setMontoCreVencidos(resultSet.getString("saldoCreVencido"));
					
					//Egresos				
					consola.setDesPendientesDis(resultSet.getString("saldoDeseembolso"));
					consola.setPresuGasAuto(resultSet.getString("saldoPresupuesto"));
					consola.setPagoInteresCaptacion(resultSet.getString("saldoInteresPagar"));
					consola.setVencimientoFonde(resultSet.getString("saldoVenciFonde"));
					consola.setGastosPendientes(resultSet.getString("saldoGastoPendiente"));
					
					//Proyecciones de vencimientos de creditos
					consola.setTotalCred15dias(resultSet.getString("credito15dias"));
					consola.setTotalCred30dias(resultSet.getString("credito30dias"));
					consola.setTotalCred60dias(resultSet.getString("credito60dias"));
														
					//Proyecciones de vencimientos de Fondeadores
					consola.setTotal15Dias(resultSet.getString("saldo15dias"));
					consola.setTotal30Dias(resultSet.getString("saldo30dias"));
					consola.setTotal60Dias(resultSet.getString("saldo60dias"));
					
					//Inv Plazo
					consola.setTotalInv15dias(resultSet.getString("inversion15dias"));
					consola.setTotalInv30dias(resultSet.getString("inversion30dias"));
					consola.setTotalInv60dias(resultSet.getString("inversion60dias"));
					
					return consola;
				}
			});
			
			consolaBean =  matches.size() > 0 ? (ConsolaBean) matches.get(0) : null;
			
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta concentrado", e);
		}
		
		return consolaBean;
	}
	
	// Consulta para obtener los detalles de la Consola
	public List<Map<String, Object>> detalleConsola(final String sucursalID, final String fechaDia, final int tipoConsulta){
		
		List<Map<String, Object>> list = null;
		
		try{
			String query = "call CONSOLADETALLECON(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteEntero(sucursalID),
						fechaDia,
						tipoConsulta,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ConsolaDAO.detalleConsola",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSOLADETALLECON(" + Arrays.toString(parametros) +")");
				List<Map<String, Object>> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Map<String, Object> mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					ResultSetMetaData rsmd = (ResultSetMetaData) resultSet.getMetaData();
					
					int columnCount = rsmd.getColumnCount();
					Map mapOfColValues = createColumnMap(columnCount);
					 
					for (int i = 1; i <= columnCount; i++) {
						  String key = getColumnKey(rsmd.getColumnName(i));
					      Object obj = getColumnValue(resultSet, i);
					              
					      mapOfColValues.put(key, obj);
					  }
					return mapOfColValues;
				}
			});

			list = matches;
			
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en detalle consola", e);
		}
		return list;
	}
	
	protected Map createColumnMap(int columnCount) {
		return CollectionFactory.createLinkedCaseInsensitiveMapIfPossible(columnCount);
	}
		
	protected String getColumnKey(String columnName) {
		  return columnName;
	}
	
	protected Object getColumnValue(ResultSet rs, int index) throws SQLException {
		         return JdbcUtils.getResultSetValue(rs, index);
	}
}
