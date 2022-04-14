package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.EsquemaautfirmaBean;


public class EsquemaautfirmaDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;

	public int mensajeExito=0;

	public EsquemaautfirmaDAO() {
		super();
	}

	// metodo de alta de  firmas autorizadas de solicitud de credito
	public MensajeTransaccionBean altaFirmasAutorizaSolCre(final EsquemaautfirmaBean esquemaautfirmaBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call ESQUEMAAUTFIRMAALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Solicitud",Utileria.convierteEntero(esquemaautfirmaBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_Esquema",Utileria.convierteEntero(esquemaautfirmaBean.getEsquemaID()));
									sentenciaStore.setInt("Par_NumFirma",Utileria.convierteEntero(esquemaautfirmaBean.getNumFirma()));
									sentenciaStore.setInt("Par_Organo",Utileria.convierteEntero(esquemaautfirmaBean.getOrganoID()));
									sentenciaStore.setDouble("Par_MontoAutor",Utileria.convierteDoble(esquemaautfirmaBean.getMontoAutor()));
									sentenciaStore.setDouble("Par_AporteCli",Utileria.convierteDoble(esquemaautfirmaBean.getAportCliente()));
									sentenciaStore.setString("Par_ComentMesaControl",esquemaautfirmaBean.getComentarioMesaControl());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(esquemaautfirmaBean.getNumTransaccion()));

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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de firmas autorizadas", e);
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


		// Metodo que llama el alta de firmas para autorizar
			public MensajeTransaccionBean grabaFirmasAutorDetalles(final EsquemaautfirmaBean esquemaautfirmaBean, final List listaDetalleFirmasAutor) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
				final long numTransacc = parametrosAuditoriaBean.getNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBeanAlta = new MensajeTransaccionBean();
						try {
							EsquemaautfirmaBean esquemaautfirma;
							esquemaautfirmaBean.setNumTransaccion(String.valueOf(numTransacc));


									for(int i=0; i<listaDetalleFirmasAutor.size(); i++){
										esquemaautfirma = (EsquemaautfirmaBean)listaDetalleFirmasAutor.get(i);
										esquemaautfirma.setSolicitudCreditoID(esquemaautfirmaBean.getSolicitudCreditoID());
										esquemaautfirma.setMontoAutor(esquemaautfirmaBean.getMontoAutor());
										esquemaautfirma.setAportCliente(esquemaautfirmaBean.getAportCliente());
										esquemaautfirma.setComentarioMesaControl((esquemaautfirmaBean.getComentarioMesaControl()));
										esquemaautfirma.setNumTransaccion(esquemaautfirmaBean.getNumTransaccion());
										mensajeBeanAlta = altaFirmasAutorizaSolCre(esquemaautfirma);
										if(mensajeBeanAlta.getNumero()!=0){
											throw new Exception(mensajeBeanAlta.getDescripcion());

										}

									}


							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(mensajeBeanAlta.getNumero());
							mensajeBean.setDescripcion(mensajeBeanAlta.getDescripcion());
							mensajeBean.setNombreControl(mensajeBeanAlta.getNombreControl());
							mensajeBean.setConsecutivoString(mensajeBeanAlta.getConsecutivoString());
						} catch (Exception e) {
							if(mensajeBeanAlta.getNumero()==0){
								mensajeBeanAlta.setNumero(999);
							}
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al grabar firmas de autor", e);
							mensajeBeanAlta.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();

						}
						return mensajeBeanAlta;
					}
				});
				return mensaje;
			}


			//Lista para grid de firmas autorizadas de solicitud de credito
			public List listaGridFirmasAutorizadas(EsquemaautfirmaBean esquemaautfirmaBean, int tipoLista){

				String query = "call ESQUEMAAUTFIRMALIS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							esquemaautfirmaBean.getSolicitudCreditoID(),
							Constantes.ENTERO_CERO,
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAAUTFIRMALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						EsquemaautfirmaBean esquemaautfirmaBean = new EsquemaautfirmaBean();

						esquemaautfirmaBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
						esquemaautfirmaBean.setEsquemaID(String.valueOf(resultSet.getInt(2)));
						esquemaautfirmaBean.setNumFirma(String.valueOf(resultSet.getInt(3)));
						esquemaautfirmaBean.setOrganoID(resultSet.getString(4));
						esquemaautfirmaBean.setDescripcionOrgano(resultSet.getString(5));

						return esquemaautfirmaBean;
					}
				});
				return matches;
			}


			//Lista para grid de firmas autorizadas de solicitud de Grupo
			public List listaGridFirmasAutorizadasGrupo(EsquemaautfirmaBean esquemaautfirmaBean, int tipoLista){

				String query = "call ESQUEMAAUTFIRMALIS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							esquemaautfirmaBean.getGrupoID(),
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAAUTFIRMALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						EsquemaautfirmaBean esquemaautfirmaBean = new EsquemaautfirmaBean();

						esquemaautfirmaBean.setGrupoID(resultSet.getString("GrupoID"));
						esquemaautfirmaBean.setEsquemaID(resultSet.getString("EsquemaID"));
						esquemaautfirmaBean.setNumFirma(resultSet.getString("NumFirma"));
						esquemaautfirmaBean.setOrganoID(resultSet.getString("OrganoID"));
						esquemaautfirmaBean.setDescripcionOrgano(resultSet.getString("Descripcion"));
						esquemaautfirmaBean.setSolicitudes(resultSet.getString("Solicitudes"));

						return esquemaautfirmaBean;
					}
				});
				return matches;
			}
			public ParametrosSesionBean getParametrosSesionBean() {
				return parametrosSesionBean;
			}

			public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
				this.parametrosSesionBean = parametrosSesionBean;
			}


}
