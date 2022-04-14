package cliente.dao;

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

import cliente.bean.CuentasTransferBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class CuentasTransferDAO  extends BaseDAO{

	public CuentasTransferDAO(){
		super();
	}


	/* Alta de Cuentas Destino*/
	public MensajeTransaccionBean altaCuentasTransfer(final CuentasTransferBean cuentas) {
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
									String query = "call CUENTASTRANSFERALT(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentas.getClienteID()));
									sentenciaStore.setInt("Par_CuentaTranID",Utileria.convierteEntero(cuentas.getCuentaTranID()));
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentas.getInstitucionID()));
									sentenciaStore.setString("Par_Clabe",cuentas.getClabe());
									sentenciaStore.setString("Par_Beneficiario",cuentas.getBeneficiario());

									sentenciaStore.setString("Par_Alias",cuentas.getAlias());
									sentenciaStore.setString("Par_FechaRegistro",cuentas.getFechaRegistro());
									sentenciaStore.setString("Par_TipoCuenta",cuentas.getTipoCuenta());
									sentenciaStore.setLong("Par_CuentaDestino",Utileria.convierteLong(cuentas.getCuentaDestino()));
									sentenciaStore.setInt("Par_ClienteDestino",Utileria.convierteEntero(cuentas.getClienteDestino()));


									sentenciaStore.setLong("Par_CuentaAhoIDCa",Utileria.convierteLong(cuentas.getCuentaAhoIDCa()));
									sentenciaStore.setInt("Par_NumClienteCa",Utileria.convierteEntero(cuentas.getNumClienteCa()));
									sentenciaStore.setInt("Par_TipoCuentaSpei",Utileria.convierteEntero(cuentas.getTipoCuentaSpei()));
									sentenciaStore.setString("Par_RFCBeneficiario",cuentas.getBeneficiarioRFC());
									sentenciaStore.setString("Par_EsPrincipal", cuentas.getEsPrincipal());
									sentenciaStore.setString("Par_AplicaPara",cuentas.getAplicaPara());

									sentenciaStore.setDouble("Par_MontoLimite", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);


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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en altas de cuentas", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}


	/* Baja de Cuentas Destino*/
	public MensajeTransaccionBean actualizaBaja(final int tipoActualizacion, final CuentasTransferBean cuentas) {
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
									String query = "call CUENTASTRANSFERACT(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?  ,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentas.getClienteID()));
									sentenciaStore.setInt("Par_CuentaTranID",Utileria.convierteEntero(cuentas.getCuentaTranID()));
									sentenciaStore.setInt("Par_UsuarioAutoriza",Utileria.convierteEntero(cuentas.getUsuarioAutoriza()));

									sentenciaStore.setString("Par_FechaAutoriza",Utileria.convierteFecha(cuentas.getFechaAutoriza()));
									sentenciaStore.setInt("Par_UsuarioBaja",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setString("Par_FechaBaja",Utileria.convierteFecha(cuentas.getFechaBaja()));
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);


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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de cuentas", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}

	/* Lista de Cuentas Destino */
	public List listaPrincipal(int tipoLista,final CuentasTransferBean cuentas) {
		String query = "call CUENTASTRANSFERLIS(?,?,?,?,?,  ?,?,?,?,?);";

		List listaResultado=null;
		try{
		Object[] parametros = {	Utileria.convierteEntero(cuentas.getClienteID()),
								Utileria.convierteEntero(cuentas.getClabe()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERLIS(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasTransferBean cuentasResultado = new CuentasTransferBean();
				if(cuentas.getTipoCuenta().equals("E")){
					cuentasResultado.setCuentaTranID(String.valueOf(resultSet.getInt("CuentaTranID")));
					cuentasResultado.setAlias(resultSet.getString("Alias"));
					cuentasResultado.setNombre(resultSet.getString("Nombre"));
					cuentasResultado.setClabe(resultSet.getString("Clabe"));

				}else if(cuentas.getTipoCuenta().equals("I")){
					cuentasResultado.setCuentaTranID(String.valueOf(resultSet.getInt("CuentaTranID")));
					cuentasResultado.setCuentaDestino(String.valueOf(resultSet.getString("CuentaAhoID")));
					cuentasResultado.setNombreClienteD(resultSet.getString("NombreCompleto"));

				}
				return cuentasResultado;
			}
		});

		listaResultado = matches;
	}catch (Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de cuentas destino", e);
	}
		return listaResultado;

	}

	public List listaSpei(int tipoLista,final CuentasTransferBean cuentas) {
		String query = "call CUENTASTRANSFERLIS(?,?,?,?,?, ?,?,?,?,?);";

		List listaResultado=null;
		try{
		Object[] parametros = {	cuentas.getClienteID(),
								cuentas.getTipoCtaBenSPEI(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERLIS(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasTransferBean cuentasResultado = new CuentasTransferBean();
					cuentasResultado.setCuentaTranID(String.valueOf(resultSet.getInt("CuentaTranID")));
					cuentasResultado.setAlias(resultSet.getString("Alias"));
					cuentasResultado.setNombre(resultSet.getString("Nombre"));
					cuentasResultado.setClabe(resultSet.getString("Clabe"));


				return cuentasResultado;
			}
		});

		listaResultado = matches;
	}catch (Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de cuentas destino", e);
	}
		return listaResultado;

	}

	public CuentasTransferBean consulta( int tipoConsulta, CuentasTransferBean cuentas){

			String query = "call CUENTASTRANSFERCON(?,?,?,?,?,	?,?,?,?,?,	?);";

			List matches=null;
			try{
			Object[] parametros = {

					Utileria.convierteEntero(cuentas.getClienteID()),
					Utileria.convierteEntero(cuentas.getCuentaTranID()),
					Constantes.ENTERO_CERO,
					tipoConsulta,
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasTranferDAO.consulta",
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERCON(" + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasTransferBean cuentasDestino = new CuentasTransferBean();
					cuentasDestino.setClienteID(String.valueOf(resultSet.getString("ClienteID")));
					cuentasDestino.setCuentaTranID(String.valueOf(resultSet.getString("CuentaTranID")));
					cuentasDestino.setInstitucionID(String.valueOf(resultSet.getString("InstitucionID")));
					cuentasDestino.setClabe(resultSet.getString("Clabe"));
					cuentasDestino.setBeneficiario(resultSet.getString("Beneficiario"));
					cuentasDestino.setAlias(resultSet.getString("Alias"));
					cuentasDestino.setFechaRegistro(resultSet.getString("FechaRegistro"));
					cuentasDestino.setEstatus(resultSet.getString("Estatus"));
					cuentasDestino.setCuentaDestino(resultSet.getString("CuentaDestino"));
					cuentasDestino.setTipoCuenta(resultSet.getString("TipoCuenta"));
					cuentasDestino.setTipoCuentaSpei(resultSet.getString("TipoCuentaSpei"));
					cuentasDestino.setBeneficiarioRFC(resultSet.getString("RFCBeneficiario"));
					cuentasDestino.setEsPrincipal(resultSet.getString("EsPrincipal"));
					cuentasDestino.setAplicaPara(resultSet.getString("AplicaPara"));
					cuentasDestino.setEstatusDomicilio(resultSet.getString("EstatusDomicilio"));

				return cuentasDestino;
				}
			});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuentas", e);
		}
		return matches.size() > 0 ? (CuentasTransferBean) matches.get(0) : null;
	}


	public CuentasTransferBean consultaSpei( int tipoConsulta, CuentasTransferBean cuentas){

		String query = "call CUENTASTRANSFERCON(?,?,?,?,?,	?,?,?,?,?,	?);";

		List matches=null;
		try{
		Object[] parametros = {

				Utileria.convierteEntero(cuentas.getClienteID()),
				Utileria.convierteEntero(cuentas.getCuentaTranID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasTranferDAO.consulta",
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERCON(" + Arrays.toString(parametros) + ")");
	matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasTransferBean cuentasDestino = new CuentasTransferBean();
				cuentasDestino.setClienteID(String.valueOf(resultSet.getString("ClienteID")));
				cuentasDestino.setCuentaTranID(String.valueOf(resultSet.getString("CuentaTranID")));
				cuentasDestino.setInstitucionID(String.valueOf(resultSet.getString("InstitucionID")));
				cuentasDestino.setClabe(resultSet.getString("Clabe"));
				cuentasDestino.setBeneficiario(resultSet.getString("Beneficiario"));
				cuentasDestino.setAlias(resultSet.getString("Alias"));
				cuentasDestino.setFechaRegistro(resultSet.getString("FechaRegistro"));
				cuentasDestino.setEstatus(resultSet.getString("Estatus"));
				cuentasDestino.setCuentaDestino(String.valueOf(resultSet.getInt("CuentaDestino")));
				cuentasDestino.setTipoCuenta(resultSet.getString("TipoCuenta"));
				cuentasDestino.setTipoCuentaSpei(resultSet.getString("TipoCuentaSpei"));
				cuentasDestino.setBeneficiarioRFC(resultSet.getString("RFCBeneficiario"));
				cuentasDestino.setEsPrincipal(resultSet.getString("EsPrincipal"));
				cuentasDestino.setAplicaPara(resultSet.getString("AplicaPara"));
				cuentasDestino.setEstatusDomicilio(resultSet.getString("EstatusDomicilio"));

			return cuentasDestino;
			}
		});

	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuentas", e);
	}
	return matches.size() > 0 ? (CuentasTransferBean) matches.get(0) : null;
}

	public CuentasTransferBean consultaBeneficiarios( int tipoConsulta, CuentasTransferBean cuentas){

		String query = "call CUENTASTRANSFERCON(?,?,?,?,?,	?,?,?,?,?,	?);";

		List matches=null;
		try{
		Object[] parametros = {

				Utileria.convierteEntero(cuentas.getClienteID()),
				Utileria.convierteEntero(cuentas.getCuentaTranID()),
				cuentas.getClabe(),
				tipoConsulta,
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasTranferDAO.consulta",
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERCON(" + Arrays.toString(parametros) + ")");
	matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasTransferBean cuentasDestino = new CuentasTransferBean();
				cuentasDestino.setClienteID(String.valueOf(resultSet.getString("ClienteID")));
				cuentasDestino.setCuentaTranID(String.valueOf(resultSet.getString("CuentaTranID")));
				cuentasDestino.setInstitucionID(String.valueOf(resultSet.getString("InstitucionID")));
				cuentasDestino.setClabe(resultSet.getString("Clabe"));
				cuentasDestino.setBeneficiario(resultSet.getString("Beneficiario"));
				cuentasDestino.setAlias(resultSet.getString("Alias"));
				cuentasDestino.setFechaRegistro(resultSet.getString("FechaRegistro"));
				cuentasDestino.setEstatus(resultSet.getString("Estatus"));
				cuentasDestino.setCuentaDestino(resultSet.getString("CuentaDestino"));
				cuentasDestino.setTipoCuenta(resultSet.getString("TipoCuenta"));
				cuentasDestino.setTipoCuentaSpei(resultSet.getString("TipoCuentaSpei"));
				cuentasDestino.setBeneficiarioRFC(resultSet.getString("RFCBeneficiario"));
				cuentasDestino.setEsPrincipal(resultSet.getString("EsPrincipal"));
				cuentasDestino.setNombre(resultSet.getString("NombreCorto"));

			return cuentasDestino;
			}
		});

	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuentas", e);
	}
	return matches.size() > 0 ? (CuentasTransferBean) matches.get(0) : null;
}

	/* Listado de Creditos por Clientes */
	public List listaCuentasTransfer(CuentasTransferBean cuentaBean, int tipoLista) {
		List  cuentaLis = null;
		try{
			// Query con el Store Procedure

			String query = "call CUENTASTRANSFERLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {

									cuentaBean.getClienteID(),
									cuentaBean.getClabe(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCuentasTransfer",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CuentasTransferBean cuentaBean = new CuentasTransferBean();
					cuentaBean.setCuentaTranID(resultSet.getString(1));
					cuentaBean.setCtaNomCompletTipoCta(resultSet.getString(2));
					return cuentaBean;
				}
			});
			cuentaLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de clientes vigentes", e);
		}
		return cuentaLis;
	}

	// CONSULTA INSTITUCION CLABE
	public CuentasTransferBean consultaInstClabe( int tipoConsulta, CuentasTransferBean cuentas){
		String query = "call CUENTASTRANSFERCON(?,?,?,?,?, ?,?,?,?,?,?);";

			List matches=null;
			try{
			Object[] parametros = {
					Utileria.convierteEntero(cuentas.getClienteID()),
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasTranferDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
				loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERCON(" + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasTransferBean cuentasDestino = new CuentasTransferBean();
					cuentasDestino.setClienteID(String.valueOf(resultSet.getString("ClienteID")));
					cuentasDestino.setInstitucionID(String.valueOf(resultSet.getString("InstitucionID")));
					cuentasDestino.setClabe(resultSet.getString("Clabe"));

				return cuentasDestino;
				}
			});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuentas", e);
		}
		return matches.size() > 0 ? (CuentasTransferBean) matches.get(0) : null;
	}

	//CONSULTA EXISTE DOMICILIACION
	public CuentasTransferBean consultaExisteDomicilia( int tipoConsulta, CuentasTransferBean cuentas){
		String query = "call CUENTASTRANSFERCON(?,?,?,?,?, ?,?,?,?,?,?);";

		List matches=null;
		try{
		Object[] parametros = {
				Utileria.convierteEntero(cuentas.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasTranferDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERCON(" + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasTransferBean cuentasDestino = new CuentasTransferBean();
					cuentasDestino.setClienteID(String.valueOf(resultSet.getString("ClienteID")));
					cuentasDestino.setClabe(resultSet.getString("Clabe"));
					cuentasDestino.setEstatusDomicilio(resultSet.getString("EstatusDomicilio"));

				return cuentasDestino;
				}
			});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuentas", e);
		}
		return matches.size() > 0 ? (CuentasTransferBean) matches.get(0) : null;
	}

	/* Consulta de Cuentas Clabe */
	public CuentasTransferBean consultaCuentaClabe( int tipoConsulta, CuentasTransferBean cuentas){

		String query = "call CUENTASTRANSFERCON(?,?,?,?,?, ?,?,?,?,?,?);";

		List matches=null;
		try{
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				cuentas.getClabe(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasTranferDAO.consultaCuentaClabe",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERCON(" + Arrays.toString(parametros) + ")");
			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasTransferBean cuentasDestino = new CuentasTransferBean();
				cuentasDestino.setClienteID(String.valueOf(resultSet.getString("ClienteID")));
				cuentasDestino.setClabe(resultSet.getString("Clabe"));
				cuentasDestino.setEstatusDomicilio(resultSet.getString("EstatusDomicilio"));

			return cuentasDestino;
			}
		});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuentas", e);
		}
		return matches.size() > 0 ? (CuentasTransferBean) matches.get(0) : null;
	}

	/*  Lista de Cuentas Clabe con Estatus de Domiciliacion: Afiliada y No Afiliada */
	public List listaCtaClabeAfiliaNOAfilia(int tipoLista,final CuentasTransferBean cuentas) {
		String query = "call CUENTASTRANSFERLIS(?,?,?,?,?, ?,?,?,?,?);";

		List listaResultado=null;
		try{
		Object[] parametros = {	cuentas.getClienteID(),
								Constantes.STRING_VACIO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASTRANSFERLIS(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasTransferBean cuentasResultado = new CuentasTransferBean();
					cuentasResultado.setClabe(resultSet.getString("Clabe"));
					cuentasResultado.setEstatusDomicilio(resultSet.getString("EstatusDomicilio"));

				return cuentasResultado;
			}
		});

		listaResultado = matches;
	}catch (Exception e){
		e.printStackTrace();
		loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Cuentas Clabe con Estatus de Domiciliacion: Afiliada y No Afiliada", e);
	}
		return listaResultado;

	}

}
