package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.DestinosCreditoBean;
import credito.bean.LineasCreditoBean;


public class DestinosCreditoDAO extends BaseDAO  {
	
	public DestinosCreditoDAO() {
		super();
	}
	
	
	//Consulta principal Destinos de credito 
		public DestinosCreditoBean consultaPrincipal(DestinosCreditoBean destinosCredito, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call DESTINOSCREDITOCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { destinosCredito.getProducCreditoID(),
									destinosCredito.getDestinoCreID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DESTINOSCREDITOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DestinosCreditoBean destinosCreditoBean = new DestinosCreditoBean();
					destinosCreditoBean.setDestinoCreID(resultSet.getString("DestinoCreID")); 
					destinosCreditoBean.setDescripcion(resultSet.getString("Descripcion")); 
					destinosCreditoBean.setDestinCredFRID(resultSet.getString("DestinCredFRID")); 
					destinosCreditoBean.setDestinCredFOMURID(resultSet.getString("DestinCredFOMURID"));
				
					destinosCreditoBean.setClasificacion(resultSet.getString("Clasificacion")); 
					destinosCreditoBean.setSubClasifID(resultSet.getString("SubClasifID"));
					
					destinosCreditoBean.setDesCredFR(resultSet.getString("DescripcionFR"));
					destinosCreditoBean.setDesCredFOMUR(resultSet.getString("DescripcionFOMUR"));
					return destinosCreditoBean;
				}
			});
			return matches.size() > 0 ? (DestinosCreditoBean) matches.get(0) : null;
		}
		
	
			
			//Consulta principal Destinos de credito 
			public DestinosCreditoBean consultaForanea(DestinosCreditoBean destinosCredito, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call DESTINOSCREDITOCON(?,?,? ,?,?,?,?,?,?,?);";
				Object[] parametros = { destinosCredito.getProducCreditoID(),
										destinosCredito.getDestinoCreID(),
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										Constantes.STRING_VACIO,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DESTINOSCREDITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						DestinosCreditoBean destinosCreditoBean = new DestinosCreditoBean();
						destinosCreditoBean.setDestinoCreID(resultSet.getString("DestinoCreID")); 
						destinosCreditoBean.setDescripcion(resultSet.getString("Descripcion")); 
						
						
						destinosCreditoBean.setDestinCredFOMURID(resultSet.getString("DestinCredFOMURID")); 
						destinosCreditoBean.setDesCredFOMUR(resultSet.getString("DescripcionFOMUR")); 
						
						destinosCreditoBean.setDestinCredFRID(resultSet.getString("DestinCredFRID"));
						destinosCreditoBean.setDesCredFR(resultSet.getString("DescripcionFR")); 						
						destinosCreditoBean.setClasificacion(resultSet.getString("Clasificacion")); 
						destinosCreditoBean.setDesClasificacion(resultSet.getString("DesClasificacion"));
					
						return destinosCreditoBean;
					}
				});
				return matches.size() > 0 ? (DestinosCreditoBean) matches.get(0) : null;
			}
		
	// Lista principal de destinos de Credito
	public List listaDestinoCredito(DestinosCreditoBean destinosCredito, int tipoLista){

		String query = "call DESTINOSCREDITOLIS(?,?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {
					destinosCredito.getDestinoCreID(),
					Utileria.convierteEntero(destinosCredito.getProducCreditoID()),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DESTINOSCREDITOLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DestinosCreditoBean destinosCreditoBean = new DestinosCreditoBean();
				destinosCreditoBean.setDestinoCreID(resultSet.getString(1)); 
				destinosCreditoBean.setDescripcion(resultSet.getString(2));
				return destinosCreditoBean;
			}
		});
		return matches;
	}
	
	
}
