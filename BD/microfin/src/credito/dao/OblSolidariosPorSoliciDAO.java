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


import credito.bean.OblSolidariosPorSoliciBean;
import credito.bean.ObliSolidariosPorSoliciDetalleBean;

public class OblSolidariosPorSoliciDAO extends BaseDAO{

	java.sql.Date fecha = null;

	public OblSolidariosPorSoliciDAO() {
		super();
	}
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";

	public MensajeTransaccionBean altaOblSolidarios(final OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean) {
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
					String query = "call OBLSOLIDARIOSPORSOLIALT(?,?,?,?,?, " +
															"?,?,?,?,?, " +
															"?,?,?,?,?," +
															"?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_SolCreditoID",Utileria.convierteEntero(oblSolidariosPorSoliciBean.getSolicitudCreditoID()));
					sentenciaStore.setInt("Par_OblSolidID",Utileria.convierteEntero(oblSolidariosPorSoliciBean.getOblSolidID()));
					sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(oblSolidariosPorSoliciBean.getClienteID()));
					sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(oblSolidariosPorSoliciBean.getProspectoID()));
					sentenciaStore.setString("Par_Estatus",OblSolidariosPorSoliciBean.ESTATUS_ALTA);

					sentenciaStore.setDouble("Par_TiempoDeConocido", Utileria.convierteDoble(oblSolidariosPorSoliciBean.getTiempoConocido()));
					sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(oblSolidariosPorSoliciBean.getParentescoID()));

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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OblSolidariosPorSoliciDAO.alta");
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
			throw new Exception(Constantes.MSG_ERROR + " .OblSolidariosPorSoliciDAO.alta");
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
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de obligados solidarios por solicitud", e);
	}
	return mensajeBean;
}
});
return mensaje;
}

	/* Consulta de Obligados Solidarios por Solicitud de Credito*/
	public ObliSolidariosPorSoliciDetalleBean consultaPrincipal(ObliSolidariosPorSoliciDetalleBean obliSolidariosPorSolicitudDetalleBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call OBLSOLIDARIOSPORSOLICON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { obliSolidariosPorSolicitudDetalleBean.getObliSolidID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDARIOSPORSOLICON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ObliSolidariosPorSoliciDetalleBean obliSolidariosPorSoliciDetalleBean = new ObliSolidariosPorSoliciDetalleBean();
				obliSolidariosPorSoliciDetalleBean.setObliSolidID(resultSet.getString(1));
				obliSolidariosPorSoliciDetalleBean.setClienteID(resultSet.getString(2));
				obliSolidariosPorSoliciDetalleBean.setProspectoID(resultSet.getString(3));
				obliSolidariosPorSoliciDetalleBean.setNombre(resultSet.getString(4));
				obliSolidariosPorSoliciDetalleBean.setParentescoID(resultSet.getString(5));
				obliSolidariosPorSoliciDetalleBean.setNombreParentesco(resultSet.getString(6));
				obliSolidariosPorSoliciDetalleBean.setTiempoConocido(resultSet.getString(7));
				return obliSolidariosPorSoliciDetalleBean;


			}
	});
		return matches.size() > 0 ? (ObliSolidariosPorSoliciDetalleBean) matches.get(0) : null;
	}



/*------------Baja de Obligados Solidarios-------------*/

	public MensajeTransaccionBean baja(final OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean, final int tipoBaja) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

/*---------------Query con el SP-------------*/
				String query = "call OBLSOLIDARIOSPORSOLIBAJ(?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {

						Utileria.convierteEntero(oblSolidariosPorSoliciBean.getSolicitudCreditoID()),
						Utileria.convierteEntero(oblSolidariosPorSoliciBean.getOblSolidID()),
						Utileria.convierteEntero(oblSolidariosPorSoliciBean.getClienteID()),
						Utileria.convierteEntero(oblSolidariosPorSoliciBean.getProspectoID()),
						tipoBaja,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDPORSOLIBAJ(  " + Arrays.toString(parametros) + ")");

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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de obligados solidarios por solicitud", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}


	public MensajeTransaccionBean grabaListaObligadosSolidarios(final OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean , final List listaObligadosSolidarios, final int tipoBaja ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					OblSolidariosPorSoliciBean oblSolidBean;
					mensajeBean = baja(oblSolidariosPorSoliciBean, tipoBaja);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaObligadosSolidarios.size(); i++){
						oblSolidBean = (OblSolidariosPorSoliciBean)listaObligadosSolidarios.get(i);
						mensajeBean = altaOblSolidarios(oblSolidBean);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de obligados solidarios por solicitud", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean grabaListaOblSolidReest(final OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean, final List listOblSolid, final int tipoBaja ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					OblSolidariosPorSoliciBean oblSolidBean;
					mensajeBean = baja(oblSolidariosPorSoliciBean, tipoBaja);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listOblSolid.size(); i++){
						oblSolidBean = (OblSolidariosPorSoliciBean)listOblSolid.get(i);
						mensajeBean = altaOblSolidarios(oblSolidBean);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de obligados solidarios por solicitud", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	public List listaAlfanumerica(OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean, int tipoLista){
		String query = "call OBLSOLIDARIOSPORSOLILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

					oblSolidariosPorSoliciBean.getSolicitudCreditoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"OblSolidariosPorSoliciDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDARIOSPORSOLILIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ObliSolidariosPorSoliciDetalleBean obliSolidariosPorSoliciDetalleBean = new ObliSolidariosPorSoliciDetalleBean();
				obliSolidariosPorSoliciDetalleBean.setObliSolidID(resultSet.getString(1));
				obliSolidariosPorSoliciDetalleBean.setClienteID(resultSet.getString(2));
				obliSolidariosPorSoliciDetalleBean.setProspectoID(resultSet.getString(3));
				obliSolidariosPorSoliciDetalleBean.setNombre(resultSet.getString(4));
				obliSolidariosPorSoliciDetalleBean.setParentescoID(resultSet.getString("ParentescoID"));
				obliSolidariosPorSoliciDetalleBean.setNombreParentesco(resultSet.getString("NombreParentesco"));
				obliSolidariosPorSoliciDetalleBean.setTiempoConocido(resultSet.getString("TiempoDeConocido"));

				return obliSolidariosPorSoliciDetalleBean;

			}
		});
		return matches;
		}

	// Lista de obligados solidarios asignados en una Reestructura de Crédito

	public List listaOblSolidReest(OblSolidariosPorSoliciBean obliSolidarioPorSoliciBean, int tipoLista){
		String query = "call OBLSOLIDARIOSPORSOLILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					obliSolidarioPorSoliciBean.getSolicitudCreditoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"OblSolidariosPorSoliciDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDARIOSPORSOLILIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ObliSolidariosPorSoliciDetalleBean oblSolidariosPorSoliciDetalleBean = new ObliSolidariosPorSoliciDetalleBean();
				oblSolidariosPorSoliciDetalleBean.setObliSolidID(resultSet.getString("OblSolidID"));
				oblSolidariosPorSoliciDetalleBean.setClienteID(resultSet.getString("ClienteID"));
				oblSolidariosPorSoliciDetalleBean.setProspectoID(resultSet.getString("ProspectoID"));
				oblSolidariosPorSoliciDetalleBean.setNombre(resultSet.getString("Nombre"));
				oblSolidariosPorSoliciDetalleBean.setParentescoID(resultSet.getString("ParentescoID"));
				oblSolidariosPorSoliciDetalleBean.setNombreParentesco(resultSet.getString("NombreParentesco"));
				oblSolidariosPorSoliciDetalleBean.setTiempoConocido(resultSet.getString("TiempoDeConocido"));

				return oblSolidariosPorSoliciDetalleBean;

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
