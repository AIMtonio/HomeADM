package inversiones.servicio;

import inversiones.bean.BeneficiariosInverBean;
import inversiones.dao.BeneficiariosInverDAO;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class BeneficiariosInverServicio extends BaseServicio {
	
	    // Variables 
		BeneficiariosInverDAO beneficiariosInverDAO = null;
		
		//Transacciones 
		public static interface Enum_Tra_BeneficiariosInver{
			int alta = 1;	
			int modifica =2;
			int elimina =3;
			int heredarBeneficiarios	=4;
		}
			
	    // tipo de consulta
		
	    public static interface Enum_Con_BeneficiariosInver { 
					int principal = 1;
				}
	  		
		public BeneficiariosInverServicio() {
			super();
		}
		
		 public static interface Enum_Lis_BeneficiariosInver {
				int principal = 1;
				int listaBeneficiarios= 2;
				int inversionesBene = 3;
			}
		 
			
		 public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, BeneficiariosInverBean beneficiario){
			 
				MensajeTransaccionBean mensaje = null;
				switch (tipoTransaccion) {
					case Enum_Tra_BeneficiariosInver.alta:		
						mensaje = beneficiariosInverDAO.altaBeneficiario(beneficiario);	
						System.out.println("tipotransaccionservicio" + tipoTransaccion );
						break;	
					case Enum_Tra_BeneficiariosInver.modifica:
						mensaje = beneficiariosInverDAO.modificaBeneficiario(beneficiario);	
						System.out.println("tipotransaccionservicio" + tipoTransaccion );
						break;
					case Enum_Tra_BeneficiariosInver.elimina:
						mensaje = beneficiariosInverDAO.eliminaBeneficiario(beneficiario);	
						System.out.println("tipotransaccionservicio" + tipoTransaccion );
						break;
					case Enum_Tra_BeneficiariosInver.heredarBeneficiarios:
						mensaje = beneficiariosInverDAO.heredarBeneficiarios(beneficiario);
						System.out.println("tipotransaccionservicio" + tipoTransaccion );
						break;
						
					
				}
				return mensaje;
			}

		public BeneficiariosInverBean consulta( int tipoConsulta, BeneficiariosInverBean beneficiariosInver){
			BeneficiariosInverBean beneficiariosInverBean = null;
			switch (tipoConsulta) {
				case Enum_Con_BeneficiariosInver.principal:		
					beneficiariosInverBean = beneficiariosInverDAO.consultaPrincipal( Enum_Con_BeneficiariosInver.principal, beneficiariosInver);				
					break;				
			}
				
			return beneficiariosInverBean;
		}

		
			public List lista(int tipoLista, BeneficiariosInverBean beneficiariosInverBean){		
				List listaBeneficiariosInver = null;
				switch (tipoLista) {
					case Enum_Lis_BeneficiariosInver.principal:		
						listaBeneficiariosInver = beneficiariosInverDAO.listaPrincipal(beneficiariosInverBean, tipoLista);				
						break;
					case Enum_Lis_BeneficiariosInver.listaBeneficiarios:		
						listaBeneficiariosInver = beneficiariosInverDAO.listaBeneficiarios(beneficiariosInverBean, tipoLista);				
						break;
					case Enum_Lis_BeneficiariosInver.inversionesBene:		
						listaBeneficiariosInver = beneficiariosInverDAO.listaInversiones(beneficiariosInverBean, tipoLista);				
						break;
				}		
				return listaBeneficiariosInver;
			}	
		 
		//------------------ Getters y Setters ------------------------------------------------------
		
		public BeneficiariosInverDAO getBeneficiariosInverDAO() {
			return beneficiariosInverDAO;
		}

		public void setBeneficiariosInverDAO(BeneficiariosInverDAO beneficiariosInverDAO) {
			this.beneficiariosInverDAO = beneficiariosInverDAO;
		}
		
	
}


