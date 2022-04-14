package nomina.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import nomina.bean.NomCapacidadPagoSolBean;
import nomina.bean.NomClavePresupBean;
import nomina.bean.NomDetCapacidadPagoSolBean;
import nomina.bean.NomTipoClavePresupBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class NomCapacidadPagoSolDAO extends BaseDAO{

	NomDetCapacidadPagoSolDAO nomDetCapacidadPagoSolDAO = null;

	public NomCapacidadPagoSolDAO(){
		super();
	}

	/*********************************************************************************************************************/
	/******************** METODO PARA DAR DE ALTA LA CAPACIDAD DE PAGO POR SOLICITUD DEL CREDITO *************************/
	public MensajeTransaccionBean capacidadPagoSolAlt(final  NomCapacidadPagoSolBean nomCapacidadPagoSolBean, final long numTransacion)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL NOMCAPACIDADPAGOSOLALT( ?,?,?,?,?,  " +
																"?,?,?,?,?, " +
																"?,?,?,?,?," +
																"?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setLong("Par_NomCapacidadPagoSolID",Utileria.convierteLong(nomCapacidadPagoSolBean.getNomCapacidadPagoSolID()));
					sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(nomCapacidadPagoSolBean.getSolicitudCreditoID()));
					sentenciaStore.setDouble("Par_CapacidadPago", Utileria.convierteDoble(nomCapacidadPagoSolBean.getCapacidadPago()));
					sentenciaStore.setDouble("Par_MontoCasasComer",Utileria.convierteDoble(nomCapacidadPagoSolBean.getMontoCasasComer()));
					sentenciaStore.setDouble("Par_MontoResguardo",Utileria.convierteDoble(nomCapacidadPagoSolBean.getMontoResguardo()));
					sentenciaStore.setDouble("Par_PorcentajeCapacidad",Utileria.convierteDoble(nomCapacidadPagoSolBean.getPorcentajeCapacidad()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setString("Aud_EmpresaID", String.valueOf(parametrosAuditoriaBean.getEmpresaID()));
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "NomCapacidadPagoSolDAO.capacidadPagoSolAlt");
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

					loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
					MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
						mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
						mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
						mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomCapacidadPagoSolDAO.capacidadPagoSolAlt");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}
					return mensajeTransaccion;
				}
			});
			if(mensajeBean ==  null){
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR + " .NomCapacidadPagoSolDAO.capacidadPagoSolAlt");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Altas de Datos SocioEconomico de Capacidad de Pago" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	/*********************************************************************************************************************/
	/********************** METODO PARA MODIFICAR LA CAPACIDAD DE PAGO POR SOLICITUD DEL CREDITO *************************/
	public MensajeTransaccionBean capacidadPagoSolMod(final NomCapacidadPagoSolBean nomCapacidadPagoSolBean, final long numTransacion)  {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL NOMCAPACIDADPAGOSOLMOD( ?,?,?,?,?,  " +
																"?,?,?,?,?, " +
																"?,?,?,?,?," +
																"?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setLong("Par_NomCapacidadPagoSolID",Utileria.convierteLong(nomCapacidadPagoSolBean.getNomCapacidadPagoSolID()));
					sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(nomCapacidadPagoSolBean.getSolicitudCreditoID()));
					sentenciaStore.setDouble("Par_CapacidadPago", Utileria.convierteDoble(nomCapacidadPagoSolBean.getCapacidadPago()));
					sentenciaStore.setDouble("Par_MontoCasasComer",Utileria.convierteDoble(nomCapacidadPagoSolBean.getMontoCasasComer()));
					sentenciaStore.setDouble("Par_MontoResguardo",Utileria.convierteDoble(nomCapacidadPagoSolBean.getMontoResguardo()));
					sentenciaStore.setDouble("Par_PorcentajeCapacidad",Utileria.convierteDoble(nomCapacidadPagoSolBean.getPorcentajeCapacidad()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setString("Aud_EmpresaID", String.valueOf(parametrosAuditoriaBean.getEmpresaID()));
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "NomCapacidadPagoSolDAO.capacidadPagoSolMod");
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

					loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
					MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
						mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
						mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
						mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomCapacidadPagoSolDAO.capacidadPagoSolMod");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}
					return mensajeTransaccion;
				}
			});
			if(mensajeBean ==  null){
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR + " .NomCapacidadPagoSolDAO.capacidadPagoSolMod");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro en la Modificacion de Datos SocioEconomico de Capacidad de Pago" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	/*********************************************************************************************************************/
	/********** METODO PARA LA CONSULTA DE INFORMACION DE  LA CAPACIDAD DE PAGO POR SOLICITUD DEL CREDITO ****************/
	public NomCapacidadPagoSolBean capacidadPagoSolCon(final NomCapacidadPagoSolBean nomCapacidadPagoSolBean,int tipoConsulta) {
		NomCapacidadPagoSolBean nomCapacidadPagoSol = null;
		try{
			//Query con el Store Procedure
			String query = "call NOMCAPACIDADPAGOSOLCON(?,?,?,?,?,?," +
													   "?,?,?,?);";
			Object[] parametros = {
					nomCapacidadPagoSolBean.getNomCapacidadPagoSolID(),
					Constantes.ENTERO_CERO,
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCAPACIDADPAGOSOLCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomCapacidadPagoSolBean nomCapacidadPagoSolBean = new NomCapacidadPagoSolBean();

					nomCapacidadPagoSolBean.setNomCapacidadPagoSolID(resultSet.getString("NomCapacidadPagoSolID"));
					nomCapacidadPagoSolBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					nomCapacidadPagoSolBean.setCapacidadPago(resultSet.getString("CapacidadPago"));
					nomCapacidadPagoSolBean.setMontoCasasComer(resultSet.getString("MontoCasasComer"));
					nomCapacidadPagoSolBean.setMontoResguardo(resultSet.getString("MontoResguardo"));
					nomCapacidadPagoSolBean.setPorcentajeCapacidad(resultSet.getString("PorcentajeCapacidad"));

					return nomCapacidadPagoSolBean;
				}
			});
			nomCapacidadPagoSol = matches.size() > 0 ? (NomCapacidadPagoSolBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta atos SocioEconomico de Capacidad de Pago", e);
		}
		return nomCapacidadPagoSol;
	}

	/********** METODO PARA LA CONSULTA DE INFORMACION DE  LA CAPACIDAD DE PAGO POR SOLICITUD DEL CREDITO ****************/
	public NomCapacidadPagoSolBean capacidadPagoSolPorSolCon(final NomCapacidadPagoSolBean nomCapacidadPagoSolBean,int tipoConsulta) {
		NomCapacidadPagoSolBean nomCapacidadPagoSol = null;
		try{
			//Query con el Store Procedure
			String query = "call NOMCAPACIDADPAGOSOLCON(?,?,?,?,?,?," +
													   "?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					nomCapacidadPagoSolBean.getSolicitudCreditoID(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCAPACIDADPAGOSOLCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomCapacidadPagoSolBean nomCapacidadPagoSolBean = new NomCapacidadPagoSolBean();

					nomCapacidadPagoSolBean.setNomCapacidadPagoSolID(resultSet.getString("NomCapacidadPagoSolID"));
					nomCapacidadPagoSolBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					nomCapacidadPagoSolBean.setCapacidadPago(resultSet.getString("CapacidadPago"));
					nomCapacidadPagoSolBean.setMontoCasasComer(resultSet.getString("MontoCasasComer"));
					nomCapacidadPagoSolBean.setMontoResguardo(resultSet.getString("MontoResguardo"));
					nomCapacidadPagoSolBean.setPorcentajeCapacidad(resultSet.getString("PorcentajeCapacidad"));

					return nomCapacidadPagoSolBean;
				}
			});
			nomCapacidadPagoSol = matches.size() > 0 ? (NomCapacidadPagoSolBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta atos SocioEconomico de Capacidad de Pago", e);
		}
		return nomCapacidadPagoSol;
	}

	/*********************************************************************************************************************/
	/************* METODO PRINCIPAL PARA EL ALTA LA INFORMACION DE CAPACIDAD DE PAGO POR SOLICITUD DE CREDITO ************/
	public MensajeTransaccionBean altaCapacidadPagoSol(final NomCapacidadPagoSolBean nomCapacidadPagoSolBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				int numProceso = 1;
				try {

					mensajeBean = capacidadPagoSolAlt(nomCapacidadPagoSolBean, parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					String nomCapacidadPagoSolID = mensajeBean.getConsecutivoString();

					// se obtienes los valores de los Claves a registrar
					String[] clasifClavePresupID = nomCapacidadPagoSolBean.getClasifClavePresupID();
					String[] descClasifClavePresup = nomCapacidadPagoSolBean.getDescClasifClavePresup();
					String[] clavePresupID = nomCapacidadPagoSolBean.getClavePresupID();
					String[] clave = nomCapacidadPagoSolBean.getClave();
					String[] descClavePresup = nomCapacidadPagoSolBean.getDescClavePresup();
					String[] monto = nomCapacidadPagoSolBean.getMonto();

					if (clasifClavePresupID != null &&  clavePresupID != null && descClavePresup != null && monto != null &&  Utileria.convierteEntero(nomCapacidadPagoSolID) > 0){

						for(int i = 0; i < clavePresupID.length; i++){
							if(Utileria.convierteDoble(monto[i])==0) {
								continue;
							}

							NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean = new NomDetCapacidadPagoSolBean();

							nomDetCapacidadPagoSolBean.setNomCapacidadPagoSolID(nomCapacidadPagoSolID);

							nomDetCapacidadPagoSolBean.setClasifClavePresupID(clasifClavePresupID[i]);
							nomDetCapacidadPagoSolBean.setDescClasifClavePresup(descClasifClavePresup[i]);
							nomDetCapacidadPagoSolBean.setClavePresupID(clavePresupID[i]);
							nomDetCapacidadPagoSolBean.setClave(clave[i]);
							nomDetCapacidadPagoSolBean.setDescClavePresup(descClavePresup[i]);
							nomDetCapacidadPagoSolBean.setMonto(monto[i]);

							mensajeBean = nomDetCapacidadPagoSolDAO.detCapacidPagoSolAlt(nomDetCapacidadPagoSolBean,  parametrosAuditoriaBean.getNumeroTransaccion());

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
					mensajeBean.setConsecutivoString(nomCapacidadPagoSolBean.getSolicitudCreditoID());
					mensajeBean.setDescripcion("Proceso Realizado Correctamente.");
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Registro de Datos SocioEconomico de Capacidad de Pago", e);
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

	/*********************************************************************************************************************/
	/************ METODO PRINCIPAL PARA MODIFICAR LA INFORMACION DE CAPACIDAD DE PAGO POR SOLICITUD DE CREDITO ***********/
	public MensajeTransaccionBean modificaCapacidadPagoSol(final NomCapacidadPagoSolBean nomCapacidadPagoSolBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean = new NomDetCapacidadPagoSolBean();

				int numProceso = 1;
				try {

					mensajeBean = capacidadPagoSolMod(nomCapacidadPagoSolBean, parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					String nomCapacidadPagoSolID = nomCapacidadPagoSolBean.getNomCapacidadPagoSolID();

					nomDetCapacidadPagoSolBean.setNomCapacidadPagoSolID(nomCapacidadPagoSolID);
					mensajeBean = nomDetCapacidadPagoSolDAO.detCapacidPagoSolBaj(nomDetCapacidadPagoSolBean, numProceso, parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					// se obtienes los valores de los Claves a registrar
					String[] clasifClavePresupID = nomCapacidadPagoSolBean.getClasifClavePresupID();
					String[] descClasifClavePresup = nomCapacidadPagoSolBean.getDescClasifClavePresup();
					String[] clavePresupID = nomCapacidadPagoSolBean.getClavePresupID();
					String[] clave = nomCapacidadPagoSolBean.getClave();
					String[] descClavePresup = nomCapacidadPagoSolBean.getDescClavePresup();
					String[] monto = nomCapacidadPagoSolBean.getMonto();

					if (clasifClavePresupID != null &&  clavePresupID != null && descClavePresup != null && monto != null &&  Utileria.convierteEntero(nomCapacidadPagoSolID) > 0){

						for(int i = 0; i < clavePresupID.length; i++){

							if(Utileria.convierteDoble(monto[i])==0) {
								continue;
							}

							nomDetCapacidadPagoSolBean = new NomDetCapacidadPagoSolBean();

							nomDetCapacidadPagoSolBean.setNomCapacidadPagoSolID(nomCapacidadPagoSolID);

							nomDetCapacidadPagoSolBean.setClasifClavePresupID(clasifClavePresupID[i]);
							nomDetCapacidadPagoSolBean.setDescClasifClavePresup(descClasifClavePresup[i]);
							nomDetCapacidadPagoSolBean.setClavePresupID(clavePresupID[i]);
							nomDetCapacidadPagoSolBean.setClave(clave[i]);
							nomDetCapacidadPagoSolBean.setDescClavePresup(descClavePresup[i]);
							nomDetCapacidadPagoSolBean.setMonto(monto[i]);

							mensajeBean = nomDetCapacidadPagoSolDAO.detCapacidPagoSolAlt(nomDetCapacidadPagoSolBean,  parametrosAuditoriaBean.getNumeroTransaccion());

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
					mensajeBean.setConsecutivoString(nomCapacidadPagoSolBean.getSolicitudCreditoID());
					mensajeBean.setDescripcion("Proceso Realizado Correctamente.");
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Registro de Datos SocioEconomico de Capacidad de Pago", e);
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


	/*********************************************************************************************************************/
	/************************ METODO PARA EL CALCULO DE CAPACIDAD DE PAGO POR SOLICITUD DE CREDITO ***********************/
	public MensajeTransaccionBean calculoCapacidadPagoSol(final NomCapacidadPagoSolBean nomCapacidadPagoSolBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMCAPACIDADPAGOSOLPRO( ?,?,?,?,?,  " +
																		"?,?,?,?,?, " +
																		"?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(nomCapacidadPagoSolBean.getSolicitudCreditoID()));
							sentenciaStore.setString("Par_ListaClasifClavPresup",nomCapacidadPagoSolBean.getListaClasifClavPresup());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "calculoCapacidadPagoSol");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomCapacidadPagoSolDAO.calculoCapacidadPagoSol");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomCapacidadPagoSolDAO.calculoCapacidadPagoSol");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el calculo de capacidad de pago" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*********************************************************************************************************************/
	/**************************** METODO PARA EL LISTADO DE LAS CASA COMERCIAL POR SOLICITUD *****************************/
	public List listaCasaComercial(final NomCapacidadPagoSolBean nomCapacidadPagoSolBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCAPACIDADPAGOSOLIS( ?,?,?,?,?," +
													    "?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				nomCapacidadPagoSolBean.getSolicitudCreditoID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomCapacidadPagoSolDAO.listaCasaComercial",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCAPACIDADPAGOSOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomCapacidadPagoSolBean nomCapacidadPagoSolBean = new NomCapacidadPagoSolBean();

					nomCapacidadPagoSolBean.setCasaComercialID(resultSet.getString("CasaComercialID"));
					nomCapacidadPagoSolBean.setNombreCasaCom(resultSet.getString("NombreCasaCom"));
					nomCapacidadPagoSolBean.setMontoCasaComercial(resultSet.getString("MontoCasaComercial"));

					return nomCapacidadPagoSolBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Casa comercial por solicitud credito ", e);
		}
		return lista;
	}

	public NomDetCapacidadPagoSolDAO getNomDetCapacidadPagoSolDAO() {
		return nomDetCapacidadPagoSolDAO;
	}

	public void setNomDetCapacidadPagoSolDAO(
			NomDetCapacidadPagoSolDAO nomDetCapacidadPagoSolDAO) {
		this.nomDetCapacidadPagoSolDAO = nomDetCapacidadPagoSolDAO;
	}


}
