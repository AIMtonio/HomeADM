package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.EsquemaAutorizaBean;
import originacion.bean.OrganoAutorizaBean;

public class OrganoAutorizaDAO extends BaseDAO {

	public OrganoAutorizaDAO(){
		super();
	}


	//Lista las firmas parametrizadas de los Esquema de Autorizacion por Producto
	//Numero de Lista en Store: 3
	public List listaGridFirmasPorProducto(OrganoAutorizaBean organoAutorizaBean, int tipoLista){
		List listaGrid = null;

		try{
		String query = "call ORGANOAUTORIZALIS(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(organoAutorizaBean.getProductoCreditoID()),
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					//Constantes.ENTERO_CERO,
					organoAutorizaBean.getUsuario(),
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EsquemaAutorizaDAO.listaGridFirmasPorProducto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ORGANOAUTORIZALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OrganoAutorizaBean organoAutoriza = new OrganoAutorizaBean();

				organoAutoriza.setEsquemaID(String.valueOf(resultSet.getInt(1)));
				organoAutoriza.setNumeroFirma(String.valueOf(resultSet.getInt(2)));
				organoAutoriza.setOrganoID(String.valueOf(resultSet.getInt(3)));
				organoAutoriza.setDescripcionOrgano(resultSet.getString(4));
				return organoAutoriza;
			}
		});
		listaGrid= matches;
		//return matches;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid firmas por producto", e);
		}
		return listaGrid;
	}

	// Baja del Esquema de Firmas por Organo y Numero de Esquema
	//Tipo de Baja: 1 .- Baja Principal
	public MensajeTransaccionBean bajaEsquemaFirmaOrgano(final OrganoAutorizaBean organoAutorizaBean, final int tipoBaja) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ORGANOAUTORIZABAJ(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_Esquema",Utileria.convierteEntero(organoAutorizaBean.getEsquemaID()));
								sentenciaStore.setInt("Par_NumFirma",Utileria.convierteEntero(organoAutorizaBean.getNumeroFirma()));
								sentenciaStore.setInt("Par_Organo",Utileria.convierteEntero(organoAutorizaBean.getOrganoID()));
								sentenciaStore.setInt("Par_Producto",Utileria.convierteEntero(organoAutorizaBean.getProductoCreditoID()));
								sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de esquema de firma ", e);

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

	// Alta del Esquema de Firmas
	public MensajeTransaccionBean altaEsquemaFirmaOrgano(final OrganoAutorizaBean organoAutorizaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ORGANOAUTORIZAALT(?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_Esquema",Utileria.convierteEntero(organoAutorizaBean.getEsquemaID()));
								sentenciaStore.setInt("Par_NumFirma",Utileria.convierteEntero(organoAutorizaBean.getNumeroFirma()));
								sentenciaStore.setInt("Par_Organo",Utileria.convierteEntero(organoAutorizaBean.getOrganoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
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
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de esquema de firma organo", e);
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

	// Moificacion del Esquema de Firmas
		public MensajeTransaccionBean modificaEsquemaAutorizacion(final OrganoAutorizaBean organoAutorizaBean) {

			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ORGANOAUTORIZAMOD(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?	,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_EsquemaMod",Utileria.convierteEntero(organoAutorizaBean.getEsquemaID()));
									sentenciaStore.setInt("Par_NumFirmaMod",Utileria.convierteEntero(organoAutorizaBean.getNumeroFirma()));
									sentenciaStore.setInt("Par_OrganoMod",Utileria.convierteEntero(organoAutorizaBean.getOrganoID()));

									sentenciaStore.setInt("Par_Esquema",Utileria.convierteEntero(organoAutorizaBean.getEsquemas()));
									sentenciaStore.setInt("Par_NumFirma",Utileria.convierteEntero(organoAutorizaBean.getNumeroFirmas()));
									sentenciaStore.setInt("Par_Organos",Utileria.convierteEntero(organoAutorizaBean.getOrganosID()));


									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
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
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificación de esquema de firma organo", e);
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
	//Graba los Esquemas de Firma de Autorizacion de las Solicitudes: Elimina y da de alta los Esquemas de Firma
	//Parametros:
	//listaBajaFirmas: Lista de beanes para dar de Baja los Esquemas de Firmas
	//listaAltaFirmas: Lista de beanes para dar de Alta los Esquemas de Firmas
	public MensajeTransaccionBean grabaEsquemasFirmas(final List listaBajaFirmas,
													  final List listaAltaFirmas,
													  final List ListaModificaFirmas,
													  final int tipoBaja) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					OrganoAutorizaBean firmasBaja;
					OrganoAutorizaBean firmasAlta;
					OrganoAutorizaBean firmasModifica;

					if(listaBajaFirmas!= null){
						for(int i=0; i<listaBajaFirmas.size(); i++){
							firmasBaja = (OrganoAutorizaBean)listaBajaFirmas.get(i);
							mensajeBean = bajaEsquemaFirmaOrgano(firmasBaja, tipoBaja);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					if(listaAltaFirmas != null){
						for(int i=0; i<listaAltaFirmas.size(); i++){
							firmasAlta = (OrganoAutorizaBean)listaAltaFirmas.get(i);
							mensajeBean = altaEsquemaFirmaOrgano(firmasAlta);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
					if(ListaModificaFirmas != null){
						for(int i=0; i<ListaModificaFirmas.size(); i++){
							firmasModifica = (OrganoAutorizaBean)ListaModificaFirmas.get(i);
							mensajeBean = modificaEsquemaAutorizacion(firmasModifica);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}


					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("El Esquema de Firmas se ha Grabado Exitosamente.");
					mensajeBean.setNombreControl("productoID");
					mensajeBean.setConsecutivoInt(Constantes.STRING_CERO);
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al grabar esquema de firma ", e);
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
	}


	//Lista para grid de firmas pendientes autorizar en la pantalla autorizacion de solicitud de credito
			public List listaGridFirmasAutorizarSolCred(OrganoAutorizaBean organoAutorizaBean, int tipoLista){

				String query = "call ORGANOAUTORIZALIS(?,?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Utileria.convierteEntero(organoAutorizaBean.getProductoCreditoID()),
							Utileria.convierteEntero(organoAutorizaBean.getSolicitudCreditoID()),
							tipoLista,

							Constantes.ENTERO_CERO,
							organoAutorizaBean.getUsuario(),
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ORGANOAUTORIZALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						OrganoAutorizaBean organoAutoriza = new OrganoAutorizaBean();

						organoAutoriza.setEsquemaID(String.valueOf(resultSet.getInt(1)));
						organoAutoriza.setNumeroFirma(String.valueOf(resultSet.getInt(2)));
						organoAutoriza.setOrganoID(String.valueOf(resultSet.getInt(3)));
						organoAutoriza.setDescripcionOrgano(resultSet.getString(4));

						return organoAutoriza;
					}
				});
				return matches;
			}


			//Lista para grid de todas las firmas  en la autorizacion de solicitud de credito
				public List listaGridFirmasSolCred(OrganoAutorizaBean organoAutorizaBean, int tipoLista){

					String query = "call ORGANOAUTORIZALIS(?,?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Utileria.convierteEntero(organoAutorizaBean.getProductoCreditoID()),
								Utileria.convierteEntero(organoAutorizaBean.getSolicitudCreditoID()),
								tipoLista,

								Constantes.ENTERO_CERO,
								organoAutorizaBean.getUsuario(),
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ORGANOAUTORIZALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							OrganoAutorizaBean organoAutoriza = new OrganoAutorizaBean();

							organoAutoriza.setEsquemaID(String.valueOf(resultSet.getInt(1)));
							organoAutoriza.setNumeroFirma(String.valueOf(resultSet.getInt(2)));
							organoAutoriza.setOrganoID(String.valueOf(resultSet.getInt(3)));
							organoAutoriza.setDescripcionOrgano(resultSet.getString(4));

							return organoAutoriza;
						}
					});
					return matches;
				}

				//Lista las firmas parametrizadas de los Esquema de Autorizacion por Firma, Producto y Usuario
				//Numero de Lista en Store: 6
				public List listaGridFirmasProdCred(OrganoAutorizaBean organoAutorizaBean, int tipoLista){
					List listaGrid = null;

					try{
					String query = "call ORGANOAUTORIZALIS(?,?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(organoAutorizaBean.getEsquemaID()),
							Utileria.convierteEntero(organoAutorizaBean.getNumeroFirma()),
							Utileria.convierteEntero(organoAutorizaBean.getOrganoID()),
							Utileria.convierteEntero(organoAutorizaBean.getProductoCreditoID()),
							Utileria.convierteEntero(organoAutorizaBean.getSolicitudCreditoID()),
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()

								};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ORGANOAUTORIZALIS(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							OrganoAutorizaBean organoAutoriza = new OrganoAutorizaBean();

							organoAutoriza.setEsquemaID(String.valueOf(resultSet.getInt(1)));
							organoAutoriza.setNumeroFirma(String.valueOf(resultSet.getInt(2)));
							organoAutoriza.setOrganoID(String.valueOf(resultSet.getInt(3)));
							organoAutoriza.setDescripcionOrgano(resultSet.getString(4));
							return organoAutoriza;
						}
					});
					listaGrid= matches;
					//return matches;

					}catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid firmas por producto", e);
					}
					return listaGrid;
				}
}
