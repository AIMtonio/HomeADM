package cliente.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.ClienteBean;
import cliente.bean.ClienteGeneralBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ClienteGeneralDAO extends BaseDAO{
	
	private ParametrosSesionBean parametrosSesionBean;
	
	public ClienteGeneralDAO() {
		super();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List listaPrincipal(ClienteGeneralBean clienteGeneralBean){
		
		try {
			String query = "call CLIENTESGENERALREP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	clienteGeneralBean.getSucursalID(),
									clienteGeneralBean.getEstatus(),
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ClienteGeneralDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESGENERALREP(" + Arrays.toString(parametros) + ")");
			
			
			return ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClienteGeneralBean clienteGeneralBean = new ClienteGeneralBean();
					clienteGeneralBean.setClienteID(resultSet.getString("ClienteID"));
					clienteGeneralBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					clienteGeneralBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					clienteGeneralBean.setPromotor(resultSet.getString("Promotor"));
					clienteGeneralBean.setEstado(resultSet.getString("Estado"));
					clienteGeneralBean.setMunicipio(resultSet.getString("Municipio"));
					clienteGeneralBean.setColonia(resultSet.getString("Colonia"));
					clienteGeneralBean.setCodigoPostal(resultSet.getString("CodigoPostal"));
					clienteGeneralBean.setDomicilio(resultSet.getString("Domicilio"));
					clienteGeneralBean.setRfc(resultSet.getString("RFC"));
					clienteGeneralBean.setCurp(resultSet.getString("CURP"));
					clienteGeneralBean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
					clienteGeneralBean.setTelefono(resultSet.getString("Telefono"));
					clienteGeneralBean.setCelular(resultSet.getString("Celular"));
					clienteGeneralBean.setCorreo(resultSet.getString("Correo"));
					clienteGeneralBean.setCuentasDestinoInternas(resultSet.getString("CuentasInternas"));
					clienteGeneralBean.setCuentasDestinoExternas(resultSet.getString("CuentasExternas"));
					return clienteGeneralBean;
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ArrayList();
	}
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
