package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Archivos;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
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

import pld.bean.SociosAltoRiesgoRepBean;

public class SociosAltoRiesgoRepDAO extends BaseDAO{
	
	java.sql.Date fecha = null;

	
	public SociosAltoRiesgoRepDAO() {
		super();
	}
	
	private final static String salidaPantalla = "S";	
	
	// Datos para reporte de Socios de Alto Riesgo //
				public List sociosAltoRiesgo( SociosAltoRiesgoRepBean sociosAltoRiesgoRepBean,
														int tipoLista){	
					List ListaResultado=null;					
					try{
					String query = "call CLIALTORIESGOREP(?,?, ?,?,?,?,?,?,?)";

					Object[] parametros ={
										sociosAltoRiesgoRepBean.getSucursalID(),
										tipoLista,
									
							    		parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										parametrosAuditoriaBean.getNombrePrograma(),
										parametrosAuditoriaBean.getSucursal(),
										parametrosAuditoriaBean.getNumeroTransaccion()};
					
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIALTORIESGOREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							SociosAltoRiesgoRepBean sociosAltoRiesgoRepBean= new SociosAltoRiesgoRepBean();
							sociosAltoRiesgoRepBean.setClienteID(resultSet.getString("ClienteID"));
							sociosAltoRiesgoRepBean.setNombreClienteID(resultSet.getString("NombreCompleto"));
							sociosAltoRiesgoRepBean.setSucursalID(resultSet.getString("SucursalID"));
							sociosAltoRiesgoRepBean.setFechaAlta(resultSet.getString("FechaAlta"));
							sociosAltoRiesgoRepBean.setDireccion(resultSet.getString("DireccionCompleta"));
							sociosAltoRiesgoRepBean.setDescOcupacion(resultSet.getString("OcupacionCli"));
							sociosAltoRiesgoRepBean.setActividadBMX(resultSet.getString("ActividadBMX"));
							sociosAltoRiesgoRepBean.setHoraEmision(resultSet.getString("HoraEmision"));
							sociosAltoRiesgoRepBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
							return sociosAltoRiesgoRepBean ;
						}
					});
					ListaResultado= matches;
					}catch(Exception e){
						 e.printStackTrace();
						 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Socios de Alto Riesgo", e);
					}
					return ListaResultado;
				}
	

	
	
}
