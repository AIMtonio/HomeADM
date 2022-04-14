package credito.dao;
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

import ventanilla.bean.IngresosOperacionesBean;
import credito.bean.CreditoDevGLBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CreditoDevGLDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;

	public CreditoDevGLDAO() {
		super();
	}
	
	//Consulta numero de quitas que se llevan por credito
	public CreditoDevGLBean consultaPrincipal(CreditoDevGLBean creditoDevGLBean, int tipoConsulta) {
		CreditoDevGLBean creditoDevGL = new CreditoDevGLBean();
		try{
			//Query con el Store Procedure
			String query = "call CREDITODEVGLCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { 
					creditoDevGLBean.getCreditoDGL(),						
					tipoConsulta,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITODEVGLCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditoDevGLBean creditoDevGL = new CreditoDevGLBean();
					creditoDevGL.setCreditoDGL(resultSet.getString("CreditoID"));
					creditoDevGL.setClienteID(resultSet.getString("ClienteID"));
					creditoDevGL.setCuentaID(resultSet.getString("CuentaID"));
					creditoDevGL.setMonto(resultSet.getString("Monto"));
					creditoDevGL.setCajaID(resultSet.getString("CajaID"));
					creditoDevGL.setSucursalID(resultSet.getString("SucursalID"));
					creditoDevGL.setFecha(resultSet.getString("Fecha"));
					return creditoDevGL;
				}
			});
		creditoDevGL = matches.size() > 0 ? (CreditoDevGLBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Devoluciones de Garantia Liquida", e);
		}
		return creditoDevGL;
	}

	// metodo que se usa en validaciones ventanilla, devolución de garantia liquida
	public String consultaGarantiaLiquida(CreditoDevGLBean creditoDevGLBean, int tipoConsulta) {
		String depGarantia = "0"; 
		
		try{
			String query = "call CREDITODEVGLCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	creditoDevGLBean.getCreditoID(),																		
									tipoConsulta,
									
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CreditoDevGLDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITODEVGLCON(" + Arrays.toString(parametros) + ")");
			
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String depositogl = new String();			
					
					depositogl=resultSet.getString("Monto");					
						return depositogl;
				}
			});
		depGarantia= matches.size() > 0 ? (String) matches.get(0) : "0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de deposito de garantia liquida", e);
		}
		return depGarantia;
	}
	
	
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
	

}

