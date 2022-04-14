package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
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

import cliente.bean.CicloCreditoBean;

import originacion.dao.SolicitudCreditoDAO;

import credito.bean.IntegraGruposBean;
import credito.bean.IntegraGruposDetalleBean;

public class IntegraGruposDAO extends BaseDAO{

	java.sql.Date fecha = null;
	SolicitudCreditoDAO solicitudCreditoDAO;

	public IntegraGruposDAO() {
		super();
	}
	private final static String salidaPantalla = "S";
/* Alta de Grupos de Credito */
	public MensajeTransaccionBean altaGrupos(final IntegraGruposBean integraGruposBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call INTEGRAGRUPOSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(integraGruposBean.getGrupoID()));
					sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(integraGruposBean.getSolicitudCreditoID()));
					sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(integraGruposBean.getClienteID()));
					sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(integraGruposBean.getProspectoID()));
					sentenciaStore.setString("Par_Estatus",integraGruposBean.getEstatus());
					sentenciaStore.setDate("Par_FechaRegistro",OperacionesFechas.conversionStrDate(integraGruposBean.getFechaRegistro()));
					sentenciaStore.setInt("Par_Ciclo",Utileria.convierteEntero(integraGruposBean.getCiclo()));
					sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(integraGruposBean.getCicloPromedioGrupal()));
					sentenciaStore.setInt("Par_Cargo",Utileria.convierteEntero(integraGruposBean.getCargo()));
					sentenciaStore.setString("Par_Salida",salidaPantalla);
					//Parametros de OutPut
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .IntegraGruposDAO.alta");
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
			throw new Exception(Constantes.MSG_ERROR + " .IntegraGruposDAO.alta");
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
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de integrantes del grupo de credito", e);
	}

	return mensajeBean;
}
});
return mensaje;
}




	/*------------Baja de Puestos-------------*/

	public MensajeTransaccionBean baja(final IntegraGruposBean integraGruposBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

/*---------------Query con el SP-------------*/
				String query = "call INTEGRAGRUPOSBAJ(?,?,?,?,?,?,?,?);";
				Object[] parametros = {

						Utileria.convierteEntero(integraGruposBean.getGrupoID()),

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
						mensaje.setDescripcion(resultSet.getString(2));
						mensaje.setNombreControl(resultSet.getString(3));
						return mensaje;
					}
				});
				return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			} catch (Exception e) {
				if(mensajeBean.getNumero()==0){
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de puesto", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}

	public MensajeTransaccionBean grabaListaGrupos(final IntegraGruposBean integraGruposBean, final List listaGrupos ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				CicloCreditoBean consultaCicloClienteBean;
				CicloCreditoBean cicloClienteBean;
				try {

					IntegraGruposBean IntegraBean;
					mensajeBean = baja(integraGruposBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaGrupos.size(); i++){
						IntegraBean = (IntegraGruposBean)listaGrupos.get(i);
						//Creamos el Bean para la Consulta del Ciclo del Cliente y del Grupo
						cicloClienteBean = new CicloCreditoBean();
						cicloClienteBean.setClienteID(IntegraBean.getClienteID());
						cicloClienteBean.setProspectoID(IntegraBean.getProspectoID());
						cicloClienteBean.setProductoCreditoID(IntegraBean.getProductoCreditoID());
						cicloClienteBean.setGrupoID(IntegraBean.getGrupoID());
						consultaCicloClienteBean = solicitudCreditoDAO.consultaCicloCredito(cicloClienteBean);
						if(consultaCicloClienteBean == null || Utileria.convierteEntero(consultaCicloClienteBean.getCicloCliente()) == 0){
							throw new Exception("Error al Calcular el Ciclo del Cliente o Prospecto");
						}
						IntegraBean.setCiclo(consultaCicloClienteBean.getCicloCliente());
						IntegraBean.setCicloPromedioGrupal(consultaCicloClienteBean.getCicloPondGrupo());
						mensajeBean = altaGrupos(IntegraBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada.");
					mensajeBean.setNombreControl("grupoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error de baja de puestos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consulta de tipo de cargo de integrantes de grupo por solicitud*/
	public IntegraGruposBean consultaTipoIntegrante(IntegraGruposBean integraGruposBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call INTEGRAGRUPOSCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	Utileria.convierteEntero(integraGruposBean.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposBean integraGruposBean = new IntegraGruposBean();

				integraGruposBean.setCargo(String.valueOf(resultSet.getInt(1)));
					return integraGruposBean;

			}
		});

		return matches.size() > 0 ? (IntegraGruposBean) matches.get(0) : null;
	}

	public IntegraGruposBean consultaSolicitud(IntegraGruposBean integraGruposBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call INTEGRAGRUPOSCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	Utileria.convierteEntero(integraGruposBean.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposBean integraGruposBean = new IntegraGruposBean();
				integraGruposBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
					return integraGruposBean;

			}
		});

		return matches.size() > 0 ? (IntegraGruposBean) matches.get(0) : null;
	}

	public List listaAlfanumerica(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposDetalleBean integraGruposDetalleBean = new IntegraGruposDetalleBean();
				integraGruposDetalleBean.setSolicitudCreditoID(resultSet.getString(1));
				integraGruposDetalleBean.setNombre(resultSet.getString(2));
				integraGruposDetalleBean.setClienteID(resultSet.getString(3));
				integraGruposDetalleBean.setProspectoID(resultSet.getString(4));
				integraGruposDetalleBean.setProductoCreditoID(resultSet.getString(5));
				integraGruposDetalleBean.setMontoSol(resultSet.getString(6));
				integraGruposDetalleBean.setMontoAu(resultSet.getString(7));
				integraGruposDetalleBean.setCargo(resultSet.getString(8));
				integraGruposDetalleBean.setSexo(resultSet.getString(9));
				integraGruposDetalleBean.setEstadoCivil(resultSet.getString(10));


				return integraGruposDetalleBean;

			}
		});
		return matches;
		}

	public List listaAltaCreditoGrupal(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposDetalleBean integraGruposDetalleBean = new IntegraGruposDetalleBean();
				integraGruposDetalleBean.setSolicitudCreditoID(resultSet.getString(1));
				integraGruposDetalleBean.setClienteID(resultSet.getString(2));
				integraGruposDetalleBean.setNombre(resultSet.getString(3));
				integraGruposDetalleBean.setProductoCreditoID(resultSet.getString(4));
				integraGruposDetalleBean.setMontoAu(resultSet.getString(5));
				integraGruposDetalleBean.setFechaInicio(resultSet.getString(6));
				integraGruposDetalleBean.setFechaVencimiento(resultSet.getString(7));
				integraGruposDetalleBean.setCreditoID(resultSet.getString(8));  // almacena numero de credito
				integraGruposDetalleBean.setFechaRegistro(resultSet.getString(9));
				return integraGruposDetalleBean;

			}
		});
		return matches;
		}

	public List listaAutorizaCreditoGrupal(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposDetalleBean integraGruposDetalleBean = new IntegraGruposDetalleBean();
				integraGruposDetalleBean.setSolicitudCreditoID(resultSet.getString(1));// Valor credito
				integraGruposDetalleBean.setClienteID(resultSet.getString(2));
				integraGruposDetalleBean.setNombre(resultSet.getString(3));
				integraGruposDetalleBean.setProductoCreditoID(resultSet.getString(4));
				integraGruposDetalleBean.setMontoAu(resultSet.getString(5));
				integraGruposDetalleBean.setCargo(resultSet.getString(6));
				integraGruposDetalleBean.setMontoSol(resultSet.getString(7));
				integraGruposDetalleBean.setMostrarTipoPrepago(resultSet.getString("MostrarTipoPrepago"));
				integraGruposDetalleBean.setTipoPrepago(resultSet.getString("TipoPrepago"));

				return integraGruposDetalleBean;

			}
		});
		return matches;
		}


	// Lista utilizada en pantalla mesa de control
	public List listaAutorizaCreditoGrupalDocCom(IntegraGruposBean integraGruposBean, int tipoLista){

		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposDetalleBean integraGruposDetalleBean = new IntegraGruposDetalleBean();
				integraGruposDetalleBean.setSolicitudCreditoID(resultSet.getString(1));// Valor credito
				integraGruposDetalleBean.setClienteID(resultSet.getString(2));
				integraGruposDetalleBean.setNombre(resultSet.getString(3));
				integraGruposDetalleBean.setProductoCreditoID(resultSet.getString(4));
				integraGruposDetalleBean.setMontoAu(resultSet.getString(5));
				integraGruposDetalleBean.setCargo(resultSet.getString(6));
				integraGruposDetalleBean.setMontoSol(resultSet.getString(7));
				integraGruposDetalleBean.setCredCheckComp(resultSet.getString(8));
				integraGruposDetalleBean.setEstatus(resultSet.getString(9));
				integraGruposDetalleBean.setCuentaID(resultSet.getString(10));
				integraGruposDetalleBean.setComentarioMesaControl(resultSet.getString(11));

				return integraGruposDetalleBean;

			}
		});
		return matches;
		}

	public List listaSolicitudCreditoGrupal(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposDetalleBean integraGruposDetalleBean = new IntegraGruposDetalleBean();


				integraGruposDetalleBean.setCreditoID(resultSet.getString("Credito"));
				integraGruposDetalleBean.setProductoDescri(resultSet.getString("ProductoDescri"));
				integraGruposDetalleBean.setFechaInicio(resultSet.getString("FechaInicio"));
				integraGruposDetalleBean.setSolEstatus(resultSet.getString("SolEstatus"));
				integraGruposDetalleBean.setIntegEstatus(resultSet.getString("IntegEstatus"));
				integraGruposDetalleBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				integraGruposDetalleBean.setProspectoID(resultSet.getString("Prospecto"));
				integraGruposDetalleBean.setSolicitudCreditoID(resultSet.getString("Solicitud"));// Valor credito
				integraGruposDetalleBean.setClienteID(resultSet.getString("Cliente"));
				integraGruposDetalleBean.setNombre(resultSet.getString("ClienteNombre"));
				integraGruposDetalleBean.setProductoCreditoID(resultSet.getString("Producto"));
				integraGruposDetalleBean.setMontoAu(resultSet.getString("MontoAutorizado"));
				integraGruposDetalleBean.setCargo(resultSet.getString("IntegCargo"));
				integraGruposDetalleBean.setMontoSol(resultSet.getString("MontoSolici"));
				integraGruposDetalleBean.setComentarioEjecutivo(resultSet.getString("ComentarioEjecutivo"));
				integraGruposDetalleBean.setRequiereGarantia(resultSet.getString("RequiereGarantia"));
				integraGruposDetalleBean.setRequiereAvales(resultSet.getString("RequiereAvales"));
				integraGruposDetalleBean.setPerAvaCruzados(resultSet.getString("PerAvaCruzados"));
				integraGruposDetalleBean.setPerGarCruzadas(resultSet.getString("PerGarCruzadas"));
				integraGruposDetalleBean.setSexo(resultSet.getString("Sexo"));
				integraGruposDetalleBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				integraGruposDetalleBean.setCiclo(resultSet.getString("Ciclo"));

				return integraGruposDetalleBean;

			}
		});
		return matches;
	}

	// lista para cambio de condiciones de calendario de pagos
	public List listaCambioCondicionesCalendario(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposDetalleBean integraGruposDetalleBean = new IntegraGruposDetalleBean();

				integraGruposDetalleBean.setSolicitudCreditoID(resultSet.getString("Solicitud"));
				integraGruposDetalleBean.setProspectoID(resultSet.getString("Prospecto"));
				integraGruposDetalleBean.setClienteID(resultSet.getString("Cliente"));
				integraGruposDetalleBean.setMontoSol(resultSet.getString("MontoSolici"));
				integraGruposDetalleBean.setSolEstatus(resultSet.getString("SolEstatus"));
				integraGruposDetalleBean.setIntegEstatus(resultSet.getString("IntegEstatus"));
				integraGruposDetalleBean.setCargo(resultSet.getString("IntegCargo"));
				integraGruposDetalleBean.setNombre(resultSet.getString("ClienteNombre"));
				integraGruposDetalleBean.setMontoSeguroVida(resultSet.getString("MontoSeguroVida"));
				integraGruposDetalleBean.setForCobroSegVida(resultSet.getString("ForCobroSegVida"));
				integraGruposDetalleBean.setMontoOriginal(resultSet.getString("MontoOriginal"));
				integraGruposDetalleBean.setForCobroComAper(resultSet.getString("ForCobroComAper"));
				integraGruposDetalleBean.setMontoComIva(resultSet.getString("MontoComIva"));
				integraGruposDetalleBean.setEstatus(resultSet.getString("Estatus"));
				integraGruposDetalleBean.setCalificaCredito(resultSet.getString("CalificaCredito"));
				integraGruposDetalleBean.setPagaIVA(resultSet.getString("PagaIVA"));

				return integraGruposDetalleBean;

			}
		});
		return matches;
		}

	//Lista de Integrantes Activos del Grupo
	public List listaIntegrantesActivos(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaIntegrantesActivos",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposBean integraGruposBean = new IntegraGruposBean();
				integraGruposBean.setCreditoID(String.valueOf(resultSet.getString(1)));
				integraGruposBean.setCuentaAhoID(String.valueOf(resultSet.getString(2)));


				return integraGruposBean;

			}
		});
		return matches;
		}

	// tambien se ocupa en la ventanilla en el pago del credito y garantia adicional en ventanilla
	public List listaIntegrantesReversaDes(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaIntegrantesActivos",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposBean integraGruposBean = new IntegraGruposBean();
				integraGruposBean.setCreditoID(String.valueOf(resultSet.getString(1)));
				integraGruposBean.setCuentaAhoID(String.valueOf(resultSet.getString(2)));
				integraGruposBean.setClienteID(String.valueOf(resultSet.getInt(3)));
				integraGruposBean.setNombreCompleto(String.valueOf(resultSet.getString(4)));
				integraGruposBean.setCargo(String.valueOf(resultSet.getString(5)));
				integraGruposBean.setSaldoExigible(String.valueOf(resultSet.getString(6)));

				return integraGruposBean;

			}
		});
		return matches;
	}

	// Lista de integrantes para usar en ventanilla por pago adelantado o finiquito
	public List listaIntegrantesPagoAdela(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
					Utileria.convierteEntero(integraGruposBean.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"IntegraGruposDAO.listaIntegrantesActivos",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposBean integraGruposBean = new IntegraGruposBean();
				integraGruposBean.setCreditoID(String.valueOf(resultSet.getString(1)));
				integraGruposBean.setCuentaAhoID(String.valueOf(resultSet.getString(2)));
				integraGruposBean.setClienteID(String.valueOf(resultSet.getInt(3)));
				integraGruposBean.setNombreCompleto(String.valueOf(resultSet.getString(4)));
				integraGruposBean.setCargo(String.valueOf(resultSet.getString(5)));
				integraGruposBean.setAdeudoTotal(String.valueOf(resultSet.getString(6)));

				return integraGruposBean;

			}
		});
		return matches;
		}

	// Lista de Cuentas Principales
	public List listaCuentaPrin(IntegraGruposBean integraGruposBean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGruposBean.getGrupoID(),
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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposBean integraGruposBean = new IntegraGruposBean();
				integraGruposBean.setClienteID(resultSet.getString(1));
				integraGruposBean.setEstatus(resultSet.getString(2));

				return integraGruposBean;

			}
		});
		return matches;
		}
	/**
	 * Lista de integrantes del grupo. Esta lista se utiliza en la pantalla de Cancelación de Créditos.
	 * @param integraGruposBean : {@link IntegraGruposBean} bean con la información del grupo y ciclo para consultar.
	 * @param tipoLista : Número de Lista
	 * @return
	 */
	public List<IntegraGruposDetalleBean> listaIntegrantesCanc(IntegraGruposBean integraGruposBean, int tipoLista) {
		String query = "call INTEGRAGRUPOSLIS("
				+ "?,?,?,?,?,		"
				+ "?,?,?,?,?);";
		Object[] parametros = {
				integraGruposBean.getGrupoID(),
				Utileria.convierteEntero(integraGruposBean.getCiclo()),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"IntegraGruposDAO.listaIntegrantesCanc",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call INTEGRAGRUPOSLIS(" + Arrays.toString(parametros) + ")");
		List<IntegraGruposDetalleBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IntegraGruposDetalleBean integraGruposDetalleBean = new IntegraGruposDetalleBean();

				integraGruposDetalleBean.setCreditoID(resultSet.getString("CreditoID"));
				integraGruposDetalleBean.setClienteID(resultSet.getString("ClienteID"));
				integraGruposDetalleBean.setNombre(resultSet.getString("NombreCompleto"));
				integraGruposDetalleBean.setMontoAu(resultSet.getString("MontoCredito"));
				integraGruposDetalleBean.setInteres(resultSet.getString("Interes"));
				integraGruposDetalleBean.setMontoGarantia(resultSet.getString("MontoGarantia"));
				integraGruposDetalleBean.setMontoComApertura(resultSet.getString("MontoComApertura"));
				integraGruposDetalleBean.setIVAComisionApert(resultSet.getString("IVAComisionApert"));
				integraGruposDetalleBean.setEstatus(resultSet.getString("Estatus"));
				return integraGruposDetalleBean;

			}
		});
		return matches;
	}

	// ---------------- SETTERS Y GETERS -----------------------------------------------------
	public void setSolicitudCreditoDAO(SolicitudCreditoDAO solicitudCreditoDAO) {
		this.solicitudCreditoDAO = solicitudCreditoDAO;
	}
}
