package tesoreria.dao;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.dao.DataAccessException;

import tesoreria.bean.AsignarChequeSucurBean;
import tesoreria.bean.TipoproveimpuesBean;

public class AsignarChequeSucurDAO extends BaseDAO{

	public AsignarChequeSucurDAO(){
		super();
	}

	public MensajeTransaccionBean asignaChequesSucur(final AsignarChequeSucurBean asignarCheque){
		final String ListaVacia="";
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						mensajeBean = bajaChequera(asignarCheque);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				// Array de beans que almacena todas las cajas que tendran la chequera seleccionada
				ArrayList chequesCajas=(ArrayList) creaListaChequerasCaja(asignarCheque);
				if(!chequesCajas.isEmpty()){

					for(int i=0;i<chequesCajas.size();i++){
						 AsignarChequeSucurBean asignaChequesACaja=(AsignarChequeSucurBean)chequesCajas.get(i);
						 mensajeBean = altaChequera(asignaChequesACaja);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Chequeras Asignadas Exitosamente.");
					mensajeBean.setNombreControl("numCtaInstit");
					}
				}catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al asignar Cheques a Cajas " + e);
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


	public MensajeTransaccionBean altaChequera(final AsignarChequeSucurBean asignarCheque){
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CAJASCHEQUERAALT(?,?,?,?,?,  ?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(asignarCheque.getInstitucionID()));
										sentenciaStore.setString("Par_NumCtaInstit",asignarCheque.getNumCtaInstit());	//se va a modificar para que no exista
										sentenciaStore.setString("Par_SucursalID", asignarCheque.getSucursalID());
										sentenciaStore.setString("Par_CajaID", asignarCheque.getCajaID());
										sentenciaStore.setInt("Par_FolioCheqInicial",Utileria.convierteEntero(asignarCheque.getFolioCheqInicial()));

										sentenciaStore.setInt("Par_FolioCheqFinal",Utileria.convierteEntero(asignarCheque.getFolioCheqFinal()));
										sentenciaStore.setString("Par_Estatus", asignarCheque.getEstatus());
										sentenciaStore.setString("Par_TipoChequera", asignarCheque.getTipoChequera());
										sentenciaStore.setLong("Par_FolioUtilizar", Utileria.convierteLong(asignarCheque.getFolioUtilizar()));

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

										sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.asignaChequesCaja");
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
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignarChequeSucurDAO.altaChequera");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
							});

							if(mensajeBean ==  null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception(Constantes.MSG_ERROR + " .AsignarChequeSucurDAO.altaChequera");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}

				}catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al asignar Cheques a Cajas " + e);
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

	// Baja de chequera por sucursal
			public MensajeTransaccionBean bajaChequera(final AsignarChequeSucurBean asignarCheque) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {

							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CAJASCHEQUERABAJ(?,?,?,  ?,?,?, ?,?,?,?,?,?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(asignarCheque.getInstitucionID()));
										sentenciaStore.setString("Par_NumCtaInstit",asignarCheque.getNumCtaInstit());	//se va a modificar para que no exista
										sentenciaStore.setString("Par_TipoChequera", asignarCheque.getTipoChequera());

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

										sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.asignaChequesCaja");
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
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de chequera por sucursal", e);
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


	public List hacerBeans(AsignarChequeSucurBean asignar){
		String [] chequesCajasID=asignar.getListaCajas().toString().split(",");
		String [] estatusCajas=asignar.getValorListaCajas().toString().split(",");
		ArrayList listaBeanCheques=new ArrayList();
		int tamañoCajas=(chequesCajasID.length-1);
		int tamañoEstatus=(estatusCajas.length-1);
		if(chequesCajasID.length>0){
			chequesCajasID[0]=chequesCajasID[0].substring(1);
			chequesCajasID[tamañoCajas]=chequesCajasID[tamañoCajas].substring(0,(chequesCajasID[tamañoCajas].length()-1));
			estatusCajas[0]=estatusCajas[0].substring(1);
			estatusCajas[tamañoEstatus]=estatusCajas[tamañoEstatus].substring(0,(estatusCajas[tamañoEstatus].length()-1));
		}
		if(!chequesCajasID[0].equals("") && !estatusCajas[0].equals("")){
			for(int i=0;i<chequesCajasID.length;i++){
				AsignarChequeSucurBean asignaChequesS= new AsignarChequeSucurBean();
				asignaChequesS.setCajaID(chequesCajasID[i]);
				asignaChequesS.setEstatus(estatusCajas[i]);
				asignaChequesS.setInstitucionID(asignar.getInstitucionID());
				asignaChequesS.setNumCtaInstit(asignar.getNumCtaInstit());
				asignaChequesS.setFolioUtilizar(asignar.getFolioUtilizar());
				asignaChequesS.setSucursalID(asignar.getSucursalID());
				asignaChequesS.setNombreSucursal(asignar.getNombreSucursal());
				asignaChequesS.setNombreInstitucion(asignar.getNombreInstitucion());

				listaBeanCheques.add(asignaChequesS);
			}
		}
		return listaBeanCheques;
	}

	private List creaListaChequerasCaja(AsignarChequeSucurBean asignar){
		StringTokenizer tokensBean = new StringTokenizer(asignar.getListaCajas(), "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaBeanCheques = new ArrayList();
		AsignarChequeSucurBean chequesCajasBean;

		while (tokensBean.hasMoreTokens()) {
			chequesCajasBean = new AsignarChequeSucurBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

			chequesCajasBean.setInstitucionID(tokensCampos[0]);
			chequesCajasBean.setNumCtaInstit(tokensCampos[1]);
			chequesCajasBean.setSucursalID(tokensCampos[2]);
			chequesCajasBean.setCajaID(tokensCampos[3]);
			chequesCajasBean.setDescripcionCaja(tokensCampos[4]);
			chequesCajasBean.setFolioCheqInicial(tokensCampos[5]);
			chequesCajasBean.setFolioCheqFinal(tokensCampos[6]);
			chequesCajasBean.setEstatus(tokensCampos[7]);
			chequesCajasBean.setTipoChequera(tokensCampos[8]);
			chequesCajasBean.setFolioUtilizar(tokensCampos[9]);

			listaBeanCheques.add(chequesCajasBean);

		}
		return listaBeanCheques;
	}

	public List ChequeCombo(int tipoLista,AsignarChequeSucurBean asignarCheque){
		List asignaChequeLista=null;
		try{
			String query = "call CAJASCHEQUERALIS(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
			Object[] parametros = {	asignarCheque.getSucursalID(),
									asignarCheque.getCajaID(),
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AsignarChequeraSucurDAO.ChequeCombo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASCHEQUERALIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AsignarChequeSucurBean chequesOpcion = new AsignarChequeSucurBean();
					chequesOpcion.setInstitucionID(String.valueOf(resultSet.getInt("InstitucionID")));
					chequesOpcion.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					chequesOpcion.setInstitucionCta(resultSet.getString("InstitucionCta"));
					chequesOpcion.setDescripLista(resultSet.getString("DescripLista"));
					return chequesOpcion;
				}
			});
			asignaChequeLista= matches;

	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de opciones de Cuentas de Cheques: "+ e);
	}
		return asignaChequeLista;
	}

	// -- Lista de Números de Cuenta que manejan Chequera  se usa en la pantalla de cancelacion de cheques(emitidos en ventanilla) --//
	public List listaCuentas(AsignarChequeSucurBean asignarChequeSucurBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call CAJASCHEQUERALIS(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
			Object[] parametros = {	asignarChequeSucurBean.getSucursalID(),
									asignarChequeSucurBean.getCajaID(),
									asignarChequeSucurBean.getInstitucionID(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASCHEQUERALIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AsignarChequeSucurBean asignarChequeSucur = new AsignarChequeSucurBean();
					asignarChequeSucur.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					asignarChequeSucur.setSucursalInstit(resultSet.getString("SucursalInstit"));
					return asignarChequeSucur;
				}
			});
			return matches;
	}

	// -- Lista de las Chequeras asignadas por sucursal, usada en Asignar Chequera a Sucursal
	public List listaChequerasPorSucursal(AsignarChequeSucurBean asignarChequeSucurBean, int tipoLista) {
		List asignaChequeLista=null;
		try{
			//Query con el Store Procedure
			String query = "call CAJASCHEQUERALIS(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
			Object[] parametros = {	Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									asignarChequeSucurBean.getInstitucionID(),
									asignarChequeSucurBean.getNumCtaInstit(),
									asignarChequeSucurBean.getTipoChequera(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASCHEQUERALIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AsignarChequeSucurBean asignarChequeSucur = new AsignarChequeSucurBean();
					asignarChequeSucur.setSucursalID(resultSet.getString("SucursalID"));
					asignarChequeSucur.setNombreSucursal(resultSet.getString("NombreSucurs"));
					asignarChequeSucur.setCajaID(resultSet.getString("CajaID"));
					asignarChequeSucur.setDescripcionCaja(resultSet.getString("DescripcionCaja"));
					asignarChequeSucur.setFolioCheqInicial(resultSet.getString("FolioCheqInicial"));
					asignarChequeSucur.setFolioCheqFinal(resultSet.getString("FolioCheqFinal"));
					asignarChequeSucur.setEstatus(resultSet.getString("Estatus"));
					asignarChequeSucur.setFolioUtilizar(resultSet.getString("FolioUtilizar"));
					return asignarChequeSucur;
				}
			});
			asignaChequeLista= matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de opciones de Cuentas de Cheques: "+ e);
		}
		return asignaChequeLista;
	}

	public AsignarChequeSucurBean consultaExisteFolio(int tipoConsulta,AsignarChequeSucurBean asignaCheque) {
		AsignarChequeSucurBean asignaChequeBean = null;
		try{
			//Query con el Store Procedure
			String query = "call CAJASCHEQUERACON(?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";
			Object[] parametros = {
									asignaCheque.getInstitucionID(),
									asignaCheque.getNumCtaInstit(),
									asignaCheque.getSucursalID(),
									asignaCheque.getCajaID(),
									asignaCheque.getFolioCheqInicial(),
									asignaCheque.getTipoChequera(),

									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AsignarChequeSucurDAO.consultaExisteFolio",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASCHEQUERACON(" + Arrays.toString(parametros) + ");");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								AsignarChequeSucurBean asignaChequeBean = new AsignarChequeSucurBean();
								asignaChequeBean.setExisteFolio(resultSet.getString("ExistenciaFolio"));

							return asignaChequeBean;

						}
			});
			asignaChequeBean= matches.size() > 0 ? (AsignarChequeSucurBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta existencia folio inicial", e);

		}
	return asignaChequeBean;
	}

	public AsignarChequeSucurBean consultaUltimoFolio(int tipoConsulta,AsignarChequeSucurBean asignaCheque) {
		AsignarChequeSucurBean asignaChequeBean = null;
		try{
			//Query con el Store Procedure
			String query = "call CAJASCHEQUERACON(?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";
			Object[] parametros = {
									asignaCheque.getInstitucionID(),
									asignaCheque.getNumCtaInstit(),
									asignaCheque.getSucursalID(),
									asignaCheque.getCajaID(),
									Constantes.ENTERO_CERO,
									asignaCheque.getTipoChequera(),

									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AsignarChequeSucurDAO.consultaUltimoFolio",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASCHEQUERACON(" + Arrays.toString(parametros) + ");");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								AsignarChequeSucurBean asignaChequeBean = new AsignarChequeSucurBean();
								asignaChequeBean.setFolioUtilizar(resultSet.getString("FolioUtilizar"));
								asignaChequeBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
								asignaChequeBean.setCuentaClabe(resultSet.getString("CueClave"));
								asignaChequeBean.setRutaCheque(resultSet.getString("RutaCheque"));

							return asignaChequeBean;

						}
			});
			asignaChequeBean= matches.size() > 0 ? (AsignarChequeSucurBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta existencia folio inicial", e);

		}
	return asignaChequeBean;
	}

	/**
	 * Consulta para verificar si el folio a utilizar se encuentra dentro del bloque asignado a la caja
	 * @param tipoConsulta
	 * @param asignaCheque
	 * @return
	 */
	public AsignarChequeSucurBean consultafolioxBloqueCheques(int tipoConsulta,AsignarChequeSucurBean asignaCheque) {
		AsignarChequeSucurBean asignaChequeBean = null;
		try{
			//Query con el Store Procedure
			String query = "call CAJASCHEQUERACON(?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";
			Object[] parametros = {
									asignaCheque.getInstitucionID(),
									asignaCheque.getNumCtaInstit(),
									asignaCheque.getSucursalID(),
									asignaCheque.getCajaID(),
									asignaCheque.getFolioCheqInicial(),
									asignaCheque.getTipoChequera(),

									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AsignarChequeSucurDAO.consultafolioxBloque",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASCHEQUERACON(" + Arrays.toString(parametros) + ");");


			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								AsignarChequeSucurBean asignaChequeBean = new AsignarChequeSucurBean();

								asignaChequeBean.setExisteFolio(resultSet.getString("ExistenciaFolio"));

							return asignaChequeBean;

						}
			});
			asignaChequeBean= matches.size() > 0 ? (AsignarChequeSucurBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta existencia folio inicial", e);

		}
	return asignaChequeBean;
	}

}
