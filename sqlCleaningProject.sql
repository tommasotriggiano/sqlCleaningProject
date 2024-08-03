--Pulizia dei dati 
Select * 
from PortfolioProject.dbo.NashvilleHousing

--
Select Saledate, CONVERT(date,Saledate)
from PortfolioProject.dbo.NashvilleHousing

--


Alter table NashvilleHousing
Add Saledate2 date;

Update dbo.NashvilleHousing
set Saledate2 = CONVERT(date,Saledate)

Select saledate2 from NashvilleHousing

Alter table NashvilleHousing
drop column saledate;

--gestire i valori mancanti di property address
Select *
from NashvilleHousing
--where PropertyAddress is null

--
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a 
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--riempio i valori mancanti con i valori presenti con lo stesso parcelid
Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a 
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--divido le stringhe di property address
select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as city
from NashvilleHousing

--aggiungo due nuove colonne
Alter table NashvilleHousing
Add Propertysplitaddress NvarChar(255);

Update NashvilleHousing
set Propertysplitaddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)


Alter table NashvilleHousing
Add Propertysplitcity NvarChar(255);

Update NashvilleHousing
set Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))

--facciamo lo stesso per ownerAddress
Select ownerAddress
from portfolioproject.dbo.nashvillehousing

--usiamo parsename
Select
Parsename(REPLACE(OwnerAddress,',','.'),3),
Parsename(REPLACE(OwnerAddress,',','.'),2),
Parsename(REPLACE(OwnerAddress,',','.'),1)
from portfolioproject.dbo.nashvillehousing


--aggiungo tre nuove colonne
Alter table PortfolioProject.dbo.NashvilleHousing
Add Ownersplitaddress NvarChar(255);

Update PortfolioProject.dbo.NashvilleHousing
set Ownersplitaddress = Parsename(REPLACE(OwnerAddress,',','.'),3);


Alter table PortfolioProject.dbo.NashvilleHousing
Add Ownersplitcity NvarChar(255);

Update PortfolioProject.dbo.NashvilleHousing
set Ownersplitcity = Parsename(REPLACE(OwnerAddress,',','.'),2)

Alter table PortfolioProject.dbo.NashvilleHousing
Add Ownersplitstate NvarChar(255);

Update PortfolioProject.dbo.NashvilleHousing
set Ownersplitstate = Parsename(REPLACE(OwnerAddress,',','.'),1)

SELECT * FROM PortfolioProject.dbo.NashvilleHousing

--Gestire y e n

SELECT DISTINCT(SoldasVacant)
from PortfolioProject.dbo.NashvilleHousing

--trasfomrare tutto in yes  o no
Update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = 'Yes'
Where SoldAsVacant = 'Y'

Update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = 'No'
Where SoldAsVacant = 'N'

--usare case statement
SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


SELECT soldasVacant,COUNT(soldasVacant) FROM PortfolioProject.dbo.NashvilleHousing   GROUP BY SoldAsVacant

--rimuovere i duplicati
WITH RowNumCTE AS (
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 LegalReference
			 ORDER BY
				UniqueID) row_num

from PortfolioProject.dbo.NashvilleHousing 
)
SELECT *  FROM rowNumCTE
WHERE row_num > 1

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
DROP Column OwnerAddress,PropertyAddress,taxDistrict

SELECT * FROM PortfolioProject.dbo.NashvilleHousing 