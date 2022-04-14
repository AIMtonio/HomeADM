package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.ClasificacionCliBean;

public class ClasificacionCliDAO extends BaseDAO{

	public ClasificacionCliDAO(){
		super();
	}


	/*=============================== METODOS ==================================*/

	/* Modificacion de todas las clasificaciones de cliente*/
	public MensajeTransaccionBean procesar(final ClasificacionCliBean clasificacionCliBean, final String eliminar) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					/* Query con el Store Procedure */
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CLASIFICACIONCLIPRO(" +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClasificaCliID", Utileria.convierteEntero(clasificacionCliBean.getClasificaCliID()));
								sentenciaStore.setString("Par_Clasificacion", clasificacionCliBean.getClasificacion());
								sentenciaStore.setDouble("Par_RangoInferior", Utileria.convierteDoble(clasificacionCliBean.getRangoInferior()));
								sentenciaStore.setDouble("Par_RangoSuperior", Utileria.convierteDoble(clasificacionCliBean.getRangoSuperior()));

								sentenciaStore.setString("Par_Elimina",eliminar);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICACIONCLIPRO(" + sentenciaStore.toString() + ")");

								return sentenciaStore;

							} //public sql exception

						} // new CallableStatementCreator
						,new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
								}
								return mensajeTransaccion;
							}// public

						}// CallableStatementCallback
						);


					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}


				} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificación de clasificación de cliente", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});

			return mensaje;
		}// fin de procesar


	/* Lista los rangos de clasificaciones para mostrar los puntajes en la pantalla*/
	public List listaPrincipal(int tipoLista) {
		String query = "call CLASIFICACIONCLILIS(?,?,?,?,?,  ?,?,?);";
		Object[] parametros = {
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICACIONCLILIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClasificacionCliBean clasificacion = new ClasificacionCliBean();

				clasificacion.setClasificaCliID(resultSet.getString("ClasificaCliID"));
				clasificacion.setClasificacion(resultSet.getString("Clasificacion"));
				clasificacion.setRangoInferior(resultSet.getString("RangoInferior"));
				clasificacion.setRangoSuperior(resultSet.getString("RangoSuperior"));

				return clasificacion;
			}
		});
		return matches;
	} // fin de lista





	/* metodo para que manda llamar el metodo procesar en el cual se llama al sp */
	public MensajeTransaccionBean modificar(final ClasificacionCliBean clasificacionCliBean,final List listaClasificaciones) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					 ClasificacionCliBean clasificacionBean;

					if(listaClasificaciones!=null){
						for(int i=0; i<listaClasificaciones.size(); i++){
							/* obtenemos un bean de la lista */
							clasificacionBean = (ClasificacionCliBean)listaClasificaciones.get(i);

							/*Si es el primero eliminara todos los registros de la tabla para insertar todos de nuevo */
							if(i==0){
								mensajeBean = procesar(clasificacionBean, "S");
							}
							else{
								mensajeBean = procesar(clasificacionBean, "N");
							}

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en proceso de clasificación clientes", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// fin de modificar


}
