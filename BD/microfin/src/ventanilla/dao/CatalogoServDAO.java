package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import credito.bean.ProspectosBean;
import ventanilla.bean.CatalogoServBean;
import ventanilla.beanWS.request.ConsultaListaServRequest;
import ventanilla.beanWS.request.ConsultaMontoServRequest;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class CatalogoServDAO extends BaseDAO{

	public CatalogoServDAO(){
		super();
	}
	public MensajeTransaccionBean altaServicio(final CatalogoServBean catalogoServBean){
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
								String query = "call CATALOGOSERVALT(?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_Origen",catalogoServBean.getOrigen());
								sentenciaStore.setString("Par_NombreServicio",catalogoServBean.getNombreServicio());
								sentenciaStore.setString("Par_RazonSocial",catalogoServBean.getRazonSocial());
								sentenciaStore.setString("Par_Direccion",catalogoServBean.getDireccion());
								sentenciaStore.setString("Par_CobraComision",catalogoServBean.getCobraComision());

								sentenciaStore.setDouble("Par_MontoComision",Utileria.convierteDoble(catalogoServBean.getMontoComision()));
								sentenciaStore.setString("Par_CtaContaCom",catalogoServBean.getCtaContaCom());
								sentenciaStore.setString("Par_CtaContaIVACom",catalogoServBean.getCtaContaIVACom());
								sentenciaStore.setString("Par_CtaPagarProv",catalogoServBean.getCtaPagarProv());
								sentenciaStore.setDouble("Par_MontoServicio",Utileria.convierteDoble(catalogoServBean.getMontoServicio()));

								sentenciaStore.setString("Par_CtaContaServ",catalogoServBean.getCtaContaServ());
								sentenciaStore.setString("Par_CtaContaIVAServ",catalogoServBean.getCtaContaIVAServ());
								sentenciaStore.setString("Par_RequiereCliente",catalogoServBean.getRequiereCliente());
								sentenciaStore.setString("Par_RequiereCredito",catalogoServBean.getRequiereCredito());
								sentenciaStore.setString("Par_BancaElect",catalogoServBean.getBancaElect());

								sentenciaStore.setString("Par_PagoAutomatico",catalogoServBean.getPagoAutomatico());
								sentenciaStore.setString("Par_CuentaClabe",catalogoServBean.getCuentaClabe());
								sentenciaStore.setString("Par_CentoCostos",catalogoServBean.getCentroCostos());
								sentenciaStore.setString("Par_Ventanilla",catalogoServBean.getVentanilla());
								sentenciaStore.setString("Par_BancaMovil",catalogoServBean.getBancaMovil());
								sentenciaStore.setInt("Par_NumServProve", Utileria.convierteEntero(catalogoServBean.getNumServProve()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Alta del servicio", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public MensajeTransaccionBean modificaServicio(final CatalogoServBean catalogoServBean){
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
								String query = "call CATALOGOSERVMOD(?,?,?,?,?, ?,?,?,?,?,"
																   +"?,?,?,?,?, ?,?,?,?,?,"
																   +"?,?,"
																   +"?,?,?,"
																   +"?,?,?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_CatalogoSerID",Utileria.convierteEntero(catalogoServBean.getCatalogoServID()));
								sentenciaStore.setString("Par_Origen",catalogoServBean.getOrigen());
								sentenciaStore.setString("Par_NombreServicio",catalogoServBean.getNombreServicio());
								sentenciaStore.setString("Par_RazonSocial",catalogoServBean.getRazonSocial());
								sentenciaStore.setString("Par_Direccion",catalogoServBean.getDireccion());

								sentenciaStore.setString("Par_CobraComision",catalogoServBean.getCobraComision());
								sentenciaStore.setDouble("Par_MontoComision",Utileria.convierteDoble(catalogoServBean.getMontoComision()));
								sentenciaStore.setString("Par_CtaContaCom",catalogoServBean.getCtaContaCom());
								sentenciaStore.setString("Par_CtaContaIVACom",catalogoServBean.getCtaContaIVACom());
								sentenciaStore.setString("Par_CtaPagarProv",catalogoServBean.getCtaPagarProv());

								sentenciaStore.setDouble("Par_MontoServicio",Utileria.convierteDoble(catalogoServBean.getMontoServicio()));
								sentenciaStore.setString("Par_CtaContaServ",catalogoServBean.getCtaContaServ());
								sentenciaStore.setString("Par_CtaContaIVAServ",catalogoServBean.getCtaContaIVAServ());
								sentenciaStore.setString("Par_RequiereCliente",catalogoServBean.getRequiereCliente());
								sentenciaStore.setString("Par_RequiereCredito",catalogoServBean.getRequiereCredito());

								sentenciaStore.setString("Par_BancaElect",catalogoServBean.getBancaElect());
								sentenciaStore.setString("Par_PagoAutomatico",catalogoServBean.getPagoAutomatico());
								sentenciaStore.setString("Par_CuentaClabe",catalogoServBean.getCuentaClabe());
								sentenciaStore.setString("Par_CentoCostos",catalogoServBean.getCentroCostos());
								sentenciaStore.setString("Par_Ventanilla",catalogoServBean.getVentanilla());
								sentenciaStore.setString("Par_BancaMovil",catalogoServBean.getBancaMovil());
								sentenciaStore.setInt("Par_NumServProve",Utileria.convierteEntero(catalogoServBean.getNumServProve()));
								sentenciaStore.setString("Par_Estatus", catalogoServBean.getEstatus());


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
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Modificacion del servicio", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// lista principal de de Servicios
	public List listaServicios(int tipoLista, CatalogoServBean catalogoServBean) {
		List listaServicios = null;
		try{
			String query = "call CATALOGOSERVLIS(?,?,?,  ?,?,?,?,?,  ?,?);";
			Object[] parametros = {
									catalogoServBean.getCatalogoServID(),
									catalogoServBean.getNombreServicio(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaServicios",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOSERVLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoServBean catalogoServBean = new CatalogoServBean();
					catalogoServBean.setCatalogoServID(resultSet.getString("CatalogoServID"));
					catalogoServBean.setNombreServicio(resultSet.getString("NombreServicio"));

					return catalogoServBean;
				}
			});
			listaServicios = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Principal de Servicios", e);
		}
		return listaServicios;
	}

	//Lista para Combo Box
	public List listaCombo(int tipoLista, CatalogoServBean catalogoServBean) {
		//Query con el Store Procedure

		String query = "call CATALOGOSERVLIS(?,?,?,  ?,?,?,?,?,  ?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"listaServicios",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOSERVLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatalogoServBean catalogoServBean = new CatalogoServBean();
				catalogoServBean.setCatalogoServID(resultSet.getString("CatalogoServID"));
				catalogoServBean.setNombreServicio(resultSet.getString("NombreServicio"));
				return catalogoServBean;
			}
		});

		return matches;
	}

	//Lista para Combo Box
	public List listaComboWS(ConsultaListaServRequest consultaListaServRequest) {
		//Query con el Store Procedure

		String query = "call CATALOGOSERVLIS(?,?,?,  ?,?,?,?,?,  ?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								consultaListaServRequest.getTipoLista(),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"listaServicios",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOSERVLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatalogoServBean catalogoServBean = new CatalogoServBean();
				catalogoServBean.setCatalogoServID(resultSet.getString("CatalogoServID"));
				catalogoServBean.setNombreServicio(resultSet.getString("NombreServicio"));
				return catalogoServBean;
			}
		});

		return matches;
	}

	public CatalogoServBean montoServicioWS(int tipoConsulta,ConsultaMontoServRequest consultaMontoServRequest) {
		//Query con el Store Procedure
		String query = "call CATALOGOSERVCON(?,?,?,?,?,	?,?,?,?);";
		Object[] parametros = {
								consultaMontoServRequest.getCatalogoServID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"montoServicios",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOSERVCON(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatalogoServBean catalogoServBean = new CatalogoServBean();
				catalogoServBean.setMontoComision(resultSet.getString("MontoComision"));
				catalogoServBean.setMontoServicio(resultSet.getString("MontoServicio"));
				catalogoServBean.setOrigen(resultSet.getString("Origen"));
				return catalogoServBean;
			}
		});
		return matches.size() > 0 ? (CatalogoServBean) matches.get(0) : null;
	}


	// consulta  principal de Servicios
	public CatalogoServBean consultaPrincipalServicios(CatalogoServBean catalogoServBean, int tipoConsulta) {
		CatalogoServBean servicios = null;
		try{
			String query = "call CATALOGOSERVCON(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = { catalogoServBean.getCatalogoServID(),

									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"consultaPrincipalServicios",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOSERVCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CatalogoServBean catalogoServ = new CatalogoServBean();

					catalogoServ.setCatalogoServID(resultSet.getString("CatalogoServID"));
					catalogoServ.setOrigen(resultSet.getString("Origen"));
					catalogoServ.setNombreServicio(resultSet.getString("NombreServicio"));
					catalogoServ.setRazonSocial(resultSet.getString("RazonSocial"));
					catalogoServ.setDireccion(resultSet.getString("Direccion"));

					catalogoServ.setCobraComision(resultSet.getString("CobraComision"));
					catalogoServ.setMontoComision(resultSet.getString("MontoComision"));
					catalogoServ.setCtaContaCom(resultSet.getString("CtaContaCom"));
					catalogoServ.setCtaContaIVACom(resultSet.getString("CtaContaIVACom"));
					catalogoServ.setCtaPagarProv(resultSet.getString("CtaPagarProv"));

					catalogoServ.setMontoServicio(resultSet.getString("MontoServicio"));
					catalogoServ.setCtaContaServ(resultSet.getString("CtaContaServ"));
					catalogoServ.setCtaContaIVAServ(resultSet.getString("CtaContaIVAServ"));
					catalogoServ.setRequiereCliente(resultSet.getString("RequiereCliente"));
					catalogoServ.setRequiereCredito(resultSet.getString("RequiereCredito"));

					catalogoServ.setBancaElect(resultSet.getString("BancaElect"));
					catalogoServ.setPagoAutomatico(resultSet.getString("PagoAutomatico"));
					catalogoServ.setCuentaClabe(resultSet.getString("CuentaClabe"));
					catalogoServ.setCentroCostos(resultSet.getString("CCostosServicio"));
					catalogoServ.setNumServProve(resultSet.getString("NumServProve"));
					catalogoServ.setVentanilla(resultSet.getString("Ventanilla"));
					catalogoServ.setBancaMovil(resultSet.getString("BancaMovil"));
					catalogoServ.setEstatus(resultSet.getString("Estatus"));

					return catalogoServ;
				}
			});
			servicios= matches.size() > 0 ? (CatalogoServBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Principal de Servicios", e);
		}
		return servicios;
	}


}
