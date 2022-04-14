package cliente.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
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


import cliente.bean.GruposNosolidariosBean;
import cliente.bean.IntegraGrupoNosolBean;
import cliente.servicio.IntegraGrupoNosolServicio.Enum_Tra_IntegraGrupos;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class IntegraGrupoNosolDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean;


	public MensajeTransaccionBean grabaListaInt(GruposNosolidariosBean gruposNosolidariosBean ){
		MensajeTransaccionBean mensaje = null;
		transaccionDAO.generaNumeroTransaccion();
		IntegraGrupoNosolBean integraGrupoNosolBean = null;

			 ArrayList listaIntegrantes = (ArrayList) listaGrid(gruposNosolidariosBean);
			 integraGrupoNosolBean = new IntegraGrupoNosolBean();
			 integraGrupoNosolBean.setGrupoID(gruposNosolidariosBean.getGrupoID());
			 mensaje= bajaIntGrupo( integraGrupoNosolBean,Enum_Tra_IntegraGrupos.elimina);
			 if(listaIntegrantes.size()>0){
			 for(int i=0; i < listaIntegrantes.size(); i++){
				 integraGrupoNosolBean = new IntegraGrupoNosolBean ();
				 integraGrupoNosolBean = (IntegraGrupoNosolBean) listaIntegrantes.get(i);
					 if(mensaje.getNumero() == 0)
						mensaje= altaIntGrupo (integraGrupoNosolBean,parametrosAuditoriaBean.getNumeroTransaccion());
				}
			 }
		return mensaje;
	}

	//-------Alta Integrantes Grupo---------------
	public MensajeTransaccionBean altaIntGrupo(final IntegraGrupoNosolBean integraGrupoNosolBean, final  long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INTEGRAGRUPONOSOLALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_GrupoID",Utileria.convierteLong(integraGrupoNosolBean.getGrupoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(integraGrupoNosolBean.getClienteID()));
									sentenciaStore.setInt("Par_NumIntegrantes",Utileria.convierteEntero(integraGrupoNosolBean.getNumIntegrantes()));
									sentenciaStore.setInt("Par_TipoIntegrantes",Utileria.convierteEntero(integraGrupoNosolBean.getTipoIntegrante()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.STRING_VACIO);
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .IntegraGrupoNosolDAO.altaGrupo");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Integrantes de Grupo" + e);
						e.printStackTrace();
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

	//-------Baja Integrantes Grupo---------------
		public MensajeTransaccionBean bajaIntGrupo(final IntegraGrupoNosolBean integraGrupoNosolBean, final int tipoBaj) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call INTEGRAGRUPOSNOSOLBAJ(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setLong("Par_GrupoID",Utileria.convierteLong(integraGrupoNosolBean.getGrupoID()));
										sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(integraGrupoNosolBean.getClienteID()));
										sentenciaStore.setInt("Par_TipoBaj",tipoBaj);

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										//Parametros de Auditoria
										sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
											mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString(1)));
											mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
											mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.STRING_VACIO);
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}

										return mensajeTransaccion;
									}
								}
								);

							if(mensajeBean ==  null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception(Constantes.MSG_ERROR + " .IntegraGrupoNosolDAO.altaGrupo");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja de Integrantes de Grupo" + e);
							e.printStackTrace();
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
	//------
	public   IntegraGrupoNosolBean consultaSaldo(IntegraGrupoNosolBean integraGrupoNosolBean, int tipoCon) {
		//Query con el Store Procedure
		String query = "call INTEGRAGRUPOSNOSOLCON(?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								integraGrupoNosolBean.getClienteID(),
								tipoCon,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"IntegraGruposNosolDAO.consultaSaldo",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSNOSOLCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGrupoNosolBean integraGrupoNosolBean = new IntegraGrupoNosolBean();
				integraGrupoNosolBean.setClienteID(resultSet.getString("ClienteID"));
				integraGrupoNosolBean.setAhorro(resultSet.getString("Ahorro"));
				integraGrupoNosolBean.setExigibleDia(resultSet.getString("ExigibleDia"));
				integraGrupoNosolBean.setTotalDia(resultSet.getString("TotalDia"));


					return integraGrupoNosolBean;

			}
		});
		return matches.size() > 0 ? (IntegraGrupoNosolBean) matches.get(0) : null;

	}

	/* Lista de integrantes de grupo */
	public List listaIntegrantes(IntegraGrupoNosolBean integraGrupoNosolBean, int tipoLista) {
			//Query con el Store Procedure
		String query = "call INTEGRAGRUPONOSOLLIS(?,?,	 ?,?,?,?,?,?,?);";
		Object[] parametros = {	integraGrupoNosolBean.getGrupoID(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"IntegraGrupoNosolDAO.ConsultaIntegrantes",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPONOSOLLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGrupoNosolBean integraGrupoNosolBean = new IntegraGrupoNosolBean();
				integraGrupoNosolBean.setGrupoID(resultSet.getString("GrupoID"));
				integraGrupoNosolBean.setClienteID(resultSet.getString("ClienteID"));
				integraGrupoNosolBean.setTipoIntegrante(resultSet.getString("TipoIntegrantes"));
				integraGrupoNosolBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				integraGrupoNosolBean.setEstatus(resultSet.getString("Estatus"));
				integraGrupoNosolBean.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
				integraGrupoNosolBean.setAhorro(resultSet.getString("Ahorros"));
				integraGrupoNosolBean.setExigibleDia(resultSet.getString("ExigibleDia"));
				integraGrupoNosolBean.setTotalDia(resultSet.getString("TotalAlDia"));
				return integraGrupoNosolBean;
			}
		});
		return matches;
	}


	//lista de creditos con su tipo de prepago (Grid de creditos Grupales)
			public List listaGrid(GruposNosolidariosBean gruposNosolidariosBean){

				List<String> clientesLis  = gruposNosolidariosBean.getLclientes();
				List<String> tipoIntegranteLis   = gruposNosolidariosBean.getLtipoIntegrante();
				ArrayList listaDetalle = new ArrayList();
				IntegraGrupoNosolBean integraGrupoNosolBean = null;
				if(clientesLis !=null){
					try{

					int tamanio = clientesLis.size();
						for(int i=0; i<tamanio; i++){

							integraGrupoNosolBean = new IntegraGrupoNosolBean();

							integraGrupoNosolBean.setNumIntegrantes(Integer.toString(i));
							integraGrupoNosolBean.setGrupoID(gruposNosolidariosBean.getGrupoID());
							integraGrupoNosolBean.setClienteID(clientesLis.get(i));
							integraGrupoNosolBean.setTipoIntegrante(tipoIntegranteLis.get(i));
							listaDetalle.add(i,integraGrupoNosolBean);
						}

					}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de Creditos Grupales", e);
				}
			}
			return listaDetalle;
		}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


}
