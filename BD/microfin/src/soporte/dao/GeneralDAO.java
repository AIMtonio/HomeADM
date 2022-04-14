package soporte.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import soporte.bean.CierreGeneralBean;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.dao.CajasVentanillaDAO;
import ventanilla.servicio.CajasVentanillaServicio.Enum_Trans_CajasVentanilla;

public class GeneralDAO extends BaseDAO {
	
	CajasVentanillaDAO cajasVentanillaDAO = null;
	ParamGeneralesDAO paramGeneralesDAO = null;
	UsuarioDAO usuarioDAO = null;

	public GeneralDAO() {
		super();
	}
	
	public static interface Enum_Con_Param{
		int pdm	= 4;
	}
	
	public static interface Enum_ParamPdm{
		String sucursalId	= "SucursalPDM";
		String cajaPrinId	= "CajaPrinPDM";
		String cajaId		= "CajaPDM";
	}
	
	/*Procesos para realizar el cierre*/	
	public MensajeTransaccionBean procesaCierre() {	
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		MensajeTransaccionBean mensajePDM = new MensajeTransaccionBean();	
		MensajeTransaccionBean mensajeBloqUsua = new MensajeTransaccionBean();	
		
		try {
			
			mensaje = cerrarDia();
			
			String menErrorCierre = mensaje.getDescripcion();
			String cotrolCierre = mensaje.getNombreControl();
			
			if(mensaje.getNumero() != 0){				
				throw new Exception(mensaje.getDescripcion());				
			}
			
			Map<String, String> parametrosPDMCon = new HashMap<String, String>();
			parametrosPDMCon = paramGeneralesDAO.consultaPDM(Enum_Con_Param.pdm);			
			
			if(parametrosPDMCon == null){				
				mensaje.setDescripcion(menErrorCierre.concat(" -- ").concat("Problemas al Consultar Parametros de la Caja"));	
				mensaje.setNombreControl(cotrolCierre);
				throw new Exception(mensaje.getDescripcion());		
			}
		
			if(parametrosPDMCon.size() > 0){
				
				CajasVentanillaBean cajasVentanillaBeanCajaPrin = new CajasVentanillaBean();				
				cajasVentanillaBeanCajaPrin.setSucursalID(parametrosPDMCon.get(Enum_ParamPdm.sucursalId));
				cajasVentanillaBeanCajaPrin.setCajaID(parametrosPDMCon.get(Enum_ParamPdm.cajaPrinId));
				try {
					mensajePDM = cajasVentanillaDAO.actualizaCajasVentanilla(cajasVentanillaBeanCajaPrin, Enum_Trans_CajasVentanilla.aperOpe);
					mensaje.setDescripcion(menErrorCierre.concat(" -- ").concat(mensajePDM.getDescripcion()));	
					
					if(mensajePDM.getNumero() > 0){	
						
						throw new Exception(mensajePDM.getDescripcion());
					}
					
					
					CajasVentanillaBean cajasVentanillaBeanCajaPub = new CajasVentanillaBean();				
					cajasVentanillaBeanCajaPub.setSucursalID(parametrosPDMCon.get(Enum_ParamPdm.sucursalId));
					cajasVentanillaBeanCajaPub.setCajaID(parametrosPDMCon.get(Enum_ParamPdm.cajaId));
					
					mensajePDM = cajasVentanillaDAO.actualizaCajasVentanilla(cajasVentanillaBeanCajaPub, Enum_Trans_CajasVentanilla.aperOpe);
					mensaje.setDescripcion(menErrorCierre.concat(" -- ").concat(mensajePDM.getDescripcion()));	
					
					if(mensajePDM.getNumero() > 0){	
						throw new Exception(mensajePDM.getDescripcion());
					}
	
				}catch (Exception e) {
					if(mensajePDM.getNumero() == 0){
						mensajePDM.setNumero(999);
					}
					mensajePDM.setDescripcion(e.getMessage());			
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Consultar Parametros de la Caja", e);
				}
				
			}
			
			// Bloqueo  automatico de Usuarios
			mensajeBloqUsua = usuarioDAO.usuarioBloqueoAut();
			if(mensajeBloqUsua.getNumero() != 0){
				mensaje.setNumero(mensajeBloqUsua.getNumero());
				mensaje.setDescripcion(mensajeBloqUsua.getDescripcion());
				throw new Exception(mensaje.getDescripcion());				
			}
			
		} catch (Exception e) {
			if(mensaje.getNumero() == 0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());			
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Procesar el Cierre", e);
		}

		return mensaje;			
	}
			 
	
	/*Consulta de procesos de bitacora Batch*/
	public MensajeTransaccionBean cerrarDia() {
		//Query con el Store Procedure
		String query = "call CIERREGENERALPRO(?,?,?,?,?,?);";
		Object[] parametros = {					
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CIERREGENERALPRO(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
              public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
            	  MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
            	  mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
            	  mensaje.setDescripcion(resultSet.getString(2));
            	  mensaje.setNombreControl(resultSet.getString(3));
					
            	  return mensaje;              
              }
		  });
		  return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}
	

	public CierreGeneralBean consultaRealizaCierre(int tipoConsulta, CierreGeneralBean cierreGeneralBean) {
		CierreGeneralBean bean = null; 
		try{
			// Query con el Store Procedure
			String query = "call CIERREGENERALCON(?, ?,?,?,?,?, ?,?);";

			Object[] parametros = { 
				tipoConsulta,
				
				parametrosAuditoriaBean.getEmpresaID(),			
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CIERREGENERALCON(  " + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					
					CierreGeneralBean beanConsulta = new CierreGeneralBean();		

					beanConsulta.setConfirmaCierre(resultSet.getString("ConfirmaCierre"));
					beanConsulta.setMsjValidacion(resultSet.getString("MsjValida"));
					beanConsulta.setFechaCierreAnt(resultSet.getString("FechaCierreAnt"));
					beanConsulta.setFechaHoraUltCie(resultSet.getString("FechaHoraUltCie"));
					beanConsulta.setTiempoUltimoCierre(resultSet.getString("TiempoUltimoCierre"));
					
					return beanConsulta;

				}
			});
			
			bean= matches.size() > 0 ? (CierreGeneralBean) matches.get(0) : null;
			
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta del cierre general", e);
		}
		return bean;
	}
	
	public CajasVentanillaDAO getCajasVentanillaDAO() {
		return cajasVentanillaDAO;
	}

	public void setCajasVentanillaDAO(CajasVentanillaDAO cajasVentanillaDAO) {
		this.cajasVentanillaDAO = cajasVentanillaDAO;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}

	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}


	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}


	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}
	
	
}
