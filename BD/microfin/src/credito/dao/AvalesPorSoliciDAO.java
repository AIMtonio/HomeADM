package credito.dao;
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

import credito.bean.AutorizaAvalesBean;
import credito.bean.AvalesPorSoliciBean;
import credito.bean.AvalesPorSoliciDetalleBean;

public class AvalesPorSoliciDAO extends BaseDAO{

	java.sql.Date fecha = null;

	public AvalesPorSoliciDAO() {
		super();
	}
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";

	public MensajeTransaccionBean altaAvales(final AvalesPorSoliciBean avalesPorSoliciBean) {
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
					String query = "call AVALESPORSOLIALT(?,?,?,?,?, " +
															"?,?,?,?,?, " +
															"?,?,?,?,?," +
															"?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_SolCreditoID",Utileria.convierteEntero(avalesPorSoliciBean.getSolicitudCreditoID()));
					sentenciaStore.setInt("Par_AvalID",Utileria.convierteEntero(avalesPorSoliciBean.getAvalID()));
					sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(avalesPorSoliciBean.getClienteID()));
					sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(avalesPorSoliciBean.getProspectoID()));
					sentenciaStore.setString("Par_Estatus",AutorizaAvalesBean.ESTATUS_ALTA);

					sentenciaStore.setDouble("Par_TiempoDeConocido", Utileria.convierteDoble(avalesPorSoliciBean.getTiempoConocido()));
					sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(avalesPorSoliciBean.getParentescoID()));

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
						mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
						//mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
						mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
						mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AvalesPorSoliciDAO.alta");
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
			throw new Exception(Constantes.MSG_ERROR + " .AvalesPorSoliciDAO.alta");
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
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de avales por solicitud", e);
	}
	return mensajeBean;
}
});
return mensaje;
}

	/* Consulta de Avales por Solicitud de Credito*/
	public AvalesPorSoliciDetalleBean consultaPrincipal(AvalesPorSoliciDetalleBean avalesBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call AVALESPORSOLICON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { avalesBean.getAvalID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AvalesPorSoliciDetalleBean avalesPorSoliciDetalleBean = new AvalesPorSoliciDetalleBean();
				avalesPorSoliciDetalleBean.setAvalID(resultSet.getString(1));
				avalesPorSoliciDetalleBean.setClienteID(resultSet.getString(2));
				avalesPorSoliciDetalleBean.setProspectoID(resultSet.getString(3));
				avalesPorSoliciDetalleBean.setNombre(resultSet.getString(4));
				avalesPorSoliciDetalleBean.setParentescoID(resultSet.getString(5));
				avalesPorSoliciDetalleBean.setNombreParentesco(resultSet.getString(6));
				avalesPorSoliciDetalleBean.setTiempoConocido(resultSet.getString(7));
				return avalesPorSoliciDetalleBean;

			}
		});
		return matches.size() > 0 ? (AvalesPorSoliciDetalleBean) matches.get(0) : null;
	}



/*------------Baja de Avales-------------*/

	public MensajeTransaccionBean baja(final AvalesPorSoliciBean avalesPorSoliciBean, final int tipoBaja) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

/*---------------Query con el SP-------------*/
				String query = "call AVALESPORSOLIBAJ(?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {

						Utileria.convierteEntero(avalesPorSoliciBean.getSolicitudCreditoID()),
						Utileria.convierteEntero(avalesPorSoliciBean.getAvalID()),
						Utileria.convierteEntero(avalesPorSoliciBean.getClienteID()),
						Utileria.convierteEntero(avalesPorSoliciBean.getProspectoID()),
						tipoBaja,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESPORSOLIBAJ(  " + Arrays.toString(parametros) + ")");

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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de avales por solicitud", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}


	public MensajeTransaccionBean grabaListaAvales(final AvalesPorSoliciBean avalesPorSoliciBean, final List listaAvales, final int tipoBaja ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					AvalesPorSoliciBean avalesBean;
					mensajeBean = baja(avalesPorSoliciBean, tipoBaja);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaAvales.size(); i++){
						avalesBean = (AvalesPorSoliciBean)listaAvales.get(i);
						mensajeBean = altaAvales(avalesBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada.");
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de avales por solicitud", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean grabaListaAvalesReest(final AvalesPorSoliciBean avalesPorSoliciBean, final List listaAvales, final int tipoBaja ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					AvalesPorSoliciBean avalesBean;
					mensajeBean = baja(avalesPorSoliciBean, tipoBaja);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaAvales.size(); i++){
						avalesBean = (AvalesPorSoliciBean)listaAvales.get(i);
						mensajeBean = altaAvales(avalesBean);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada.");
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de avales por solicitud", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	public List listaAlfanumerica(AvalesPorSoliciBean avalesPorSoliciBean, int tipoLista){
		String query = "call AVALESPORSOLILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

					avalesPorSoliciBean.getSolicitudCreditoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AvalesPorSoliciDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESPORSOLILIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AvalesPorSoliciDetalleBean avalesPorSoliciDetalleBean = new AvalesPorSoliciDetalleBean();
				avalesPorSoliciDetalleBean.setAvalID(resultSet.getString(1));
				avalesPorSoliciDetalleBean.setClienteID(resultSet.getString(2));
				avalesPorSoliciDetalleBean.setProspectoID(resultSet.getString(3));
				avalesPorSoliciDetalleBean.setNombre(resultSet.getString(4));
				avalesPorSoliciDetalleBean.setParentescoID(resultSet.getString("ParentescoID"));
				avalesPorSoliciDetalleBean.setNombreParentesco(resultSet.getString("NombreParentesco"));
				avalesPorSoliciDetalleBean.setTiempoConocido(resultSet.getString("TiempoDeConocido"));

				return avalesPorSoliciDetalleBean;

			}
		});
		return matches;
		}

	// Lista de avales asignados en una Reestructura de Crédito

	public List listaAvalesReest(AvalesPorSoliciBean avalesPorSoliciBean, int tipoLista){
		String query = "call AVALESPORSOLILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

					avalesPorSoliciBean.getSolicitudCreditoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AvalesPorSoliciDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESPORSOLILIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AvalesPorSoliciDetalleBean avalesPorSoliciDetalleBean = new AvalesPorSoliciDetalleBean();
				avalesPorSoliciDetalleBean.setAvalID(resultSet.getString("AvalID"));
				avalesPorSoliciDetalleBean.setClienteID(resultSet.getString("ClienteID"));
				avalesPorSoliciDetalleBean.setProspectoID(resultSet.getString("ProspectoID"));
				avalesPorSoliciDetalleBean.setNombre(resultSet.getString("Nombre"));
				avalesPorSoliciDetalleBean.setEstatusSolicitud(resultSet.getString("EstatusSolicitud"));
				avalesPorSoliciDetalleBean.setParentescoID(resultSet.getString("ParentescoID"));
				avalesPorSoliciDetalleBean.setNombreParentesco(resultSet.getString("NombreParentesco"));
				avalesPorSoliciDetalleBean.setTiempoConocido(resultSet.getString("TiempoDeConocido"));

				return avalesPorSoliciDetalleBean;

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
