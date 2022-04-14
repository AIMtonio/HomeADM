package fondeador.dao;
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

import cuentas.bean.TiposCuentaBean;


import fondeador.bean.InstitutFondeoBean;

public class InstitutFondeoDAO extends BaseDAO{

	public InstitutFondeoDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------
    //-----alta de Instituciones de Fondeo
	public MensajeTransaccionBean alta(final InstitutFondeoBean institutFondeoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call INSTITUTFONDEOALT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_TipoFondeador", institutFondeoBean.getTipoFondeador());
							sentenciaStore.setString("Par_CobraISR", institutFondeoBean.getCobraISR());
							sentenciaStore.setString("Par_RazonSocInstFo", institutFondeoBean.getRazonSocInstFo());
							sentenciaStore.setString("Par_NombreInstitFon", institutFondeoBean.getNombreInstitFon());
							sentenciaStore.setString("Par_Estatus", institutFondeoBean.getEstatus());

							sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(institutFondeoBean.getInstitucionID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(institutFondeoBean.getClienteID()));
							sentenciaStore.setString("Par_NombreCliente", institutFondeoBean.getNombreCliente());

							sentenciaStore.setString("Par_NumCtaInstit", institutFondeoBean.getNumCtaInstit());
							sentenciaStore.setString("Par_CuentaClabe", institutFondeoBean.getCuentaClabe());

							sentenciaStore.setString("Par_NombreTitular", institutFondeoBean.getNombreTitular());
							sentenciaStore.setInt("Par_IDInstitucion", Utileria.convierteEntero(institutFondeoBean.getInstitucionBanc()));
							sentenciaStore.setInt("Par_CentroCostos", Utileria.convierteEntero(institutFondeoBean.getCentroCostos()));

							sentenciaStore.setString("Par_RFC", institutFondeoBean.getRFC());
							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(institutFondeoBean.getEstadoID()));
							sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(institutFondeoBean.getMunicipioID()));
							sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(institutFondeoBean.getLocalidadID()));
							sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(institutFondeoBean.getColoniaID()));

							sentenciaStore.setString("Par_Calle", institutFondeoBean.getCalle());
							sentenciaStore.setString("Par_NumeroCasa", institutFondeoBean.getNumeroCasa());
							sentenciaStore.setString("Par_NumInterior", institutFondeoBean.getNumInterior());
							sentenciaStore.setString("Par_Piso", institutFondeoBean.getPiso());
							sentenciaStore.setString("Par_PrimECalle", institutFondeoBean.getPrimEntreCalle());

							sentenciaStore.setString("Par_SegECalle", institutFondeoBean.getSegEntreCalle());
							sentenciaStore.setString("Par_CP", institutFondeoBean.getCP());
							sentenciaStore.setString("Par_RepresenLegal", institutFondeoBean.getRepLegal());
							sentenciaStore.setString("Par_CapturaIndica", institutFondeoBean.getCapturaIndica());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de institucion de fondeo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion de Instituciones de Fondeo  */
	public MensajeTransaccionBean modifica(final InstitutFondeoBean institutFondeoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call INSTITUTFONDEOMOD("
									+ "?,?,?,?,?,			"
									+ "?,?,?,?,?,			"
									+ "?,?,?,?,?,			"
									+ "?,?,?,?,?,			"
									+ "?,?,?,?,?,			"
									+ "?,?,?,?,?,			"
									+ "?,?,?,?,?,			"
									+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_InstitutFondID", Utileria.convierteEntero(institutFondeoBean.getInstitutFondID()));
							sentenciaStore.setString("Par_TipoFondeador", institutFondeoBean.getTipoFondeador());
							sentenciaStore.setString("Par_CobraISR", institutFondeoBean.getCobraISR());
							sentenciaStore.setString("Par_RazonSocInstFo", institutFondeoBean.getRazonSocInstFo());
							sentenciaStore.setString("Par_NombreInstitFon", institutFondeoBean.getNombreInstitFon());
							sentenciaStore.setString("Par_Estatus", institutFondeoBean.getEstatus());
							sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(institutFondeoBean.getInstitucionID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(institutFondeoBean.getClienteID()));

							sentenciaStore.setString("Par_NombreCliente", institutFondeoBean.getNombreCliente());
							sentenciaStore.setString("Par_NumCtaInstit", institutFondeoBean.getNumCtaInstit());
							sentenciaStore.setString("Par_CuentaClabe", institutFondeoBean.getCuentaClabe());
							sentenciaStore.setString("Par_NombreTitular", institutFondeoBean.getNombreTitular());
							sentenciaStore.setInt("Par_IDInstitucion", Utileria.convierteEntero(institutFondeoBean.getInstitucionBanc()));
							sentenciaStore.setInt("Par_CentroCostos", Utileria.convierteEntero(institutFondeoBean.getCentroCostos()));

							sentenciaStore.setString("Par_RFC", institutFondeoBean.getRFC());
							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(institutFondeoBean.getEstadoID()));
							sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(institutFondeoBean.getMunicipioID()));
							sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(institutFondeoBean.getLocalidadID()));
							sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(institutFondeoBean.getColoniaID()));

							sentenciaStore.setString("Par_Calle", institutFondeoBean.getCalle());
							sentenciaStore.setString("Par_NumeroCasa", institutFondeoBean.getNumeroCasa());
							sentenciaStore.setString("Par_NumInterior", institutFondeoBean.getNumInterior());
							sentenciaStore.setString("Par_Piso", institutFondeoBean.getPiso());
							sentenciaStore.setString("Par_PrimECalle", institutFondeoBean.getPrimEntreCalle());

							sentenciaStore.setString("Par_SegECalle", institutFondeoBean.getSegEntreCalle());
							sentenciaStore.setString("Par_CP", institutFondeoBean.getCP());
							sentenciaStore.setString("Par_RepresenLegal", institutFondeoBean.getRepLegal());
							sentenciaStore.setString("Par_CapturaIndica", institutFondeoBean.getCapturaIndica());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion de instituciones de fondeo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/* Consulta Instituciones de Fondeo por Llave Principal*/
	public InstitutFondeoBean consultaPrincipal(InstitutFondeoBean institutFondeo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call INSTITUTFONDEOCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	institutFondeo.getInstitutFondID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"InstitutFondeoDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUTFONDEOCON(" +Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					InstitutFondeoBean institutFondeo = new InstitutFondeoBean();

					institutFondeo.setInstitutFondID(String.valueOf(resultSet.getInt("InstitutFondID")));
					institutFondeo.setTipoFondeador(resultSet.getString("TipoFondeador"));
					institutFondeo.setCobraISR(resultSet.getString("CobraISR"));
					institutFondeo.setNombreInstitFon(resultSet.getString("NombreInstitFon"));
					institutFondeo.setRazonSocInstFo(resultSet.getString("RazonSocInstFo"));
					institutFondeo.setEstatus(resultSet.getString("Estatus"));
					institutFondeo.setInstitucionID(String.valueOf(resultSet.getInt("InstitucionID")));
					institutFondeo.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
					institutFondeo.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					institutFondeo.setCuentaClabe(resultSet.getString("CuentaClabe"));
					institutFondeo.setNombreTitular(resultSet.getString("NombreTitular"));
					institutFondeo.setIDInstitucionBanc(resultSet.getString("IDInstitucion"));
					institutFondeo.setCentroCostos(resultSet.getString("CentroCostos"));
					institutFondeo.setRFC(resultSet.getString("RFC"));
					institutFondeo.setEstadoID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("EstadoID"),3)));
					institutFondeo.setMunicipioID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("MunicipioID"),5)));
					institutFondeo.setCalle(resultSet.getString("Calle"));
					institutFondeo.setNumeroCasa(resultSet.getString("NumeroCasa"));
					institutFondeo.setNumInterior(resultSet.getString("NumInterior"));
					institutFondeo.setPiso(resultSet.getString("Piso"));
					institutFondeo.setPrimEntreCalle(resultSet.getString("PrimeraEntreCalle"));
					institutFondeo.setSegEntreCalle(resultSet.getString("SegundaEntreCalle"));
					institutFondeo.setLocalidadID(resultSet.getString("LocalidadID"));
					institutFondeo.setColoniaID(resultSet.getString("ColoniaID"));
					institutFondeo.setCP(resultSet.getString("CP"));
					institutFondeo.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
					institutFondeo.setRepLegal(resultSet.getString("RepresentanteLegal"));
					institutFondeo.setCapturaIndica(resultSet.getString("CapturaIndica"));
					return institutFondeo;

			}
		});

		return matches.size() > 0 ? (InstitutFondeoBean) matches.get(0) : null;
	}


	/* Consuta Institucion Fondeo por Llave Foranea*/
	public InstitutFondeoBean consultaForanea(InstitutFondeoBean institutFondeo, int tipoConsulta) {
		InstitutFondeoBean institutFondeoConsulta = new InstitutFondeoBean();
		try{
			//Query con el Store Procedure
			String query = "call INSTITUTFONDEOCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									institutFondeo.getInstitutFondID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"InstitutFondeoDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUTFONDEOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						InstitutFondeoBean institutFondeo = new InstitutFondeoBean();
						institutFondeo.setInstitutFondID(resultSet.getString("InstitutFondID"));
						institutFondeo.setNombreInstitFon(resultSet.getString("NombreInstitFon"));
						institutFondeo.setTipoInstitID(resultSet.getString("TipoInstitID"));
						institutFondeo.setDescripcionTipoIns(resultSet.getString("Descripcion"));
						institutFondeo.setNacionalidad(resultSet.getString("NacionalidadIns"));
						institutFondeo.setDescripNacionalidad(resultSet.getString("DescripNac"));
						institutFondeo.setCobraISR(resultSet.getString("CobraISR"));
						institutFondeo.setTipoFondeador(resultSet.getString("TipoFondeador"));
						institutFondeo.setCapturaIndica(resultSet.getString("CapturaIndica"));
						return institutFondeo;

				}
			});
			institutFondeoConsulta =  matches.size() > 0 ? (InstitutFondeoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta foranea de instituciones de fondeo ", e);
		}
		return institutFondeoConsulta;
	}


	/* Lista de Instituciones  */
	public List listaPrincipal(InstitutFondeoBean institutFondeo, int tipoLista) {
		//Query con el Store Procedure
		String query = "call INSTITUTFONDEOLIS(?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {	institutFondeo.getNombreInstitFon(),
											tipoLista,
											Constantes.ENTERO_CERO,
											Constantes.ENTERO_CERO,
											Constantes.FECHA_VACIA,
											Constantes.STRING_VACIO,
											"InstitutFondeoDAO.listaPrincipal",
											Constantes.ENTERO_CERO,
											Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUTFONDEOLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InstitutFondeoBean institutFondeo = new InstitutFondeoBean();
				institutFondeo.setInstitutFondID(String.valueOf(resultSet.getInt(1)));
				institutFondeo.setNombreInstitFon(resultSet.getString(2));

				return institutFondeo;
			}
		});

		return matches;
	}
	//Combo de Tipos de Institucion
		public List listaTiposIsntitucion(int tipoLista) {
			List listaInstit = null;
			try{
			//Query con el Store Procedure
			String query = "call TIPOSINSTITUCIONLIS(?,?,?, ?,?,?, ?,?);";
			Object[] parametros = {tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"InstitutFondeoDAO.listaCombo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSINSTITUCIONLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					InstitutFondeoBean institutFondeoBean = new InstitutFondeoBean();
					institutFondeoBean.setTipoInstitID(String.valueOf(resultSet.getInt(1)));
					institutFondeoBean.setDescripcion(resultSet.getString(2));
					return institutFondeoBean;
				}
			});
			listaInstit =  matches;
			}catch(Exception e){
				e.printStackTrace();
			}
			return listaInstit;
		}

		//Combo de Tipos de Institucion
		public List listaInstitucion(int tipoLista) {
			List listaInstit = null;
			try{
				//Query con el Store Procedure
				String query = "call INSTITUTFONDEOLIS(?,?,?, ?,?,?, ?,?,?);";
				Object[] parametros = {
						Constantes.STRING_VACIO,
						tipoLista,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"InstitutFondeoDAO.listaCombo",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUTFONDEOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						InstitutFondeoBean institutFondeoBean = new InstitutFondeoBean();
						institutFondeoBean.setInstitutFondID(String.valueOf(resultSet.getInt(1)));
						institutFondeoBean.setNombreInstitFon(resultSet.getString(2));
						return institutFondeoBean;
					}
				});

				listaInstit =  matches;
			}catch(Exception e){
				e.printStackTrace();
			}
			return listaInstit;
		}
		/* Lista de Fondeadores para Seguimiento de Campo*/
		public List listaFondeador(InstitutFondeoBean institutFondeo, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call INSTITUTFONDEOCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = {	institutFondeo.getInstitutFondID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"InstitutFondeoDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITUTFONDEOCON(" +Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						InstitutFondeoBean institutFondeo = new InstitutFondeoBean();
						institutFondeo.setInstitutFondID(String.valueOf(resultSet.getInt(1)));
						institutFondeo.setNombreInstitFon(resultSet.getString(2));
						return institutFondeo;

				}
			});

			return matches;
		}


}


