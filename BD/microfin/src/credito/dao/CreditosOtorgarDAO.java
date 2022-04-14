package credito.dao;
import org.pentaho.di.ui.core.dialog.ShowMessageDialog;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.SistemaLogging;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.core.CollectionFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;



import credito.bean.CreditosOtorgarBean;



public class CreditosOtorgarDAO extends BaseDAO{

	java.sql.Date fecha = null;
	public ParametrosSesionBean parametrosSesionBean = null;
	public CreditosOtorgarDAO() {
		super();
	}
	private final static String salidaPantalla = "S";


	public MensajeTransaccionBean altaCreditosOtorgar(final CreditosOtorgarBean creditos,final CreditosOtorgarBean creditosOtorgarBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSOTORGARPRO(?,?,?,?,?,?,   ?,?,?,?,?,  ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_CreditoID",creditos.getCredito());
								sentenciaStore.setString("Par_Estatus",creditos.getValor());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
						    	return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Monitor de Desembolso de Credito", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	//Consulta Monto Total Creditos pendientes por Otorgar
		public CreditosOtorgarBean consultaPrincipal(CreditosOtorgarBean creditosOtorgarBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CREDITOSOTORGARCON(?,? ,?,?,?,?,?,?);";
			Object[] parametros = { tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSOTORGARCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CreditosOtorgarBean creditosOtorgarBean = new CreditosOtorgarBean();
					creditosOtorgarBean.setMontoTotal(resultSet.getString("MontoTotal"));

					return creditosOtorgarBean;
				}
			});
			return matches.size() > 0 ? (CreditosOtorgarBean) matches.get(0) : null;
		}


		public List<Map<String, Object>> detalleCreditos(final int tipoConsulta, final String productoCredito, final String sucursal, final String empresaNomina){

			List<Map<String, Object>> list = null;

			try{
				String query = "call CREDITOSOTORGARCON(?,?,?,?,?, ?,?,?,?,?, ?);";
				Object[] parametros = {
							tipoConsulta,
							productoCredito,
							sucursal,
							empresaNomina,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,

							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"CreditosOtorgarDAO.detalleCreditos",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSOTORGARCON(" + Arrays.toString(parametros) +")");
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

		public MensajeTransaccionBean grabaEstatus(final CreditosOtorgarBean creditosOtorgarBean,final List listaCreditosOtorgar,final int tipoModifica) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						CreditosOtorgarBean creditos;
							for(int i=0; i<listaCreditosOtorgar.size(); i++){
								creditos = (CreditosOtorgarBean)listaCreditosOtorgar.get(i);
								creditos.setCreditoID(creditosOtorgarBean.getCreditoID());
								mensajeBean = altaCreditosOtorgar(creditos,creditosOtorgarBean);

									if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Creditos Otorgar", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
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

