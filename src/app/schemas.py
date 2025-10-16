from decimal import Decimal
from datetime import datetime

import pydantic
from pydantic import BaseModel, Field

from app.types import TransactionType


class Base(BaseModel):
    model_config = pydantic.ConfigDict(from_attributes=True)


class User(Base):
    id: int
    name: str = Field(max_length=64)


class UserCreate(Base):
    id: int
    name: str


class TransactionBase(Base):
    amount: Decimal
    type: TransactionType
    uid: str = Field(max_length=36)
    created_at: datetime
    user_id: int


class TransactionAdd(TransactionBase):
    ...


class Transaction(TransactionBase):
    ...


class UserBalance(Base):
    balance: Decimal
