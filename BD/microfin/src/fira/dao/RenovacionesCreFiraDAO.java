package fira.dao;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import fira.bean.RepRenovacionesFiraBean;

public class RenovacionesCreFiraDAO  extends BaseDAO {
	
	ParametrosSesionBean parametrosSesionBean;
	
	public RenovacionesCreFiraDAO() {
		super();
	}
	
	@SuppressWarnings("rawtypes")
	public List listaRenovaciones( RepRenovacionesFiraBean repRenovacionesBean){	
		List ListaResultado=null;
		try{
		String query = "call RENOVACIONESCREAGROREP(?,?,?,?,?, ?,?,?,?,?, "
				+ 							   "?)";

		Object[] parametros ={
							Utileria.convierteFecha(repRenovacionesBean.getFechaInicial()),
							Utileria.convierteFecha(repRenovacionesBean.getFechaFinal()),
							Utileria.convierteEntero(repRenovacionesBean.getSucursalID()),
							Utileria.convierteEntero(repRenovacionesBean.getProductoCredito()),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RENOVACIONESCREAGROREP(  " + Arrays.toString(parametros) + ")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RepRenovacionesFiraBean repRenovacionesBean= new RepRenovacionesFiraBean();
						
						repRenovacionesBean.setClienteID(resultSet.getString("ClienteID"));
						repRenovacionesBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						repRenovacionesBean.setCreditoOrigenID(resultSet.getString("CreditoOrigenID"));
						repRenovacionesBean.setCreditoDestinoID(resultSet.getString("CreditoDestinoID"));
						repRenovacionesBean.setProductoOrigen(resultSet.getString("ProductoOrigen"));
						repRenovacionesBean.setProductoDestino(resultSet.getString("ProductoDestino"));
						repRenovacionesBean.setFechaRenovacion(resultSet.getString("FechaMinistrado"));
						repRenovacionesBean.setEstatusCredito(resultSet.getString("Estatus"));
						repRenovacionesBean.setPagoSostenido(resultSet.getString("NumPagoSoste"));	
						repRenovacionesBean.setSaldoTotalCapital(resultSet.getString("SaldoTotalCapital"));
						repRenovacionesBean.setSaldoInteresTotal(resultSet.getString("SaldoInteresTotal"));
						repRenovacionesBean.setSaldoMoratorioTotal(resultSet.getString("SaldoMoratorioTotal"));
						repRenovacionesBean.setHora(resultSet.getString("Hora"));
				
					return repRenovacionesBean ;
				}
			});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Renovaciones", e);
		}
		return ListaResultado;
	}	

}
